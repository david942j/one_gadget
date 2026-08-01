/*
 * park_stub — load a target libc and park, so a debugger can hijack a fully
 * initialized thread to test a one_gadget candidate. Works both natively and
 * under qemu-user (cross-arch), because it is self-describing: it pre-allocates
 * scratch and reports its own libc base, so the driver needs no inferior
 * function calls and no /proc access from the (possibly remote) debugger.
 *
 * Usage: ALETHEIA_STUB_OUT=<file> park_stub <path-to-target-libc.so>
 *   - mmaps a zeroed scratch region (no driver-side inferior mmap needed),
 *   - dlopen()s the target and finds its load base from the *guest*
 *     /proc/self/maps (correct under qemu-user),
 *   - writes "ALETHEIA_BASE=..\nALETHEIA_SCRATCH=.." to $ALETHEIA_STUB_OUT,
 *   - parks in aletheia_park() (break there to inject state).
 *
 * Self-injection mode ($ALETHEIA_SELFINJECT set): instead of parking for a
 * debugger, the stub applies the plan itself (set registers/sp, seed the L2
 * command) and jumps to the gadget. This runs the whole test under plain
 * qemu-user with no gdbstub -- needed where qemu's gdbstub mishandles the
 * fork'd child of a posix_spawn gadget (arm), killing the L2 shell. The plan
 * text is passed in the env var; see self_inject() for its grammar.
 *
 * Build (per arch, ahead of time):
 *   cc                    -O0 -g -o park_stub_aarch64 park_stub.c -ldl
 *   x86_64-linux-gnu-gcc  -O0 -g -o park_stub_x86_64  park_stub.c -ldl
 */
#define _GNU_SOURCE
#include <dlfcn.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/mman.h>

#define SCRATCH_SIZE 0x20000 /* keep in sync with Satisfier::SCRATCH_SIZE */
#define STRING_POOL  0x100  /* benign default: a readable, zero-filled scratch slot */
#define COMMAND_POOL 0x200  /* where the L2 "ls /" command is seeded (cf. satisfier) */

/* Break here to inject: libc is fully loaded and scratch is mapped. */
void aletheia_park(void) {
    for (;;) {
        pause();
    }
}

#ifdef __arm__
/* --- TEMPORARY HACK: clone3 -> clone for qemu-arm -----------------------------
 * qemu-arm doesn't implement clone3 (EABI 435), which glibc 2.43's posix_spawn
 * forks with, so posix_spawn gadgets can't spawn a shell under emulation. This
 * redirects the target libc's __clone3 wrapper -- which the loader calls as
 *   __clone3(struct clone_args *a, size_t size, int (*fn)(void*), void *arg)
 * -- to a shim that translates to the legacy clone (syscall 120, which qemu-arm
 * does implement) via glibc's own __clone. Gated on $ALETHEIA_CLONE3_HACK and a
 * byte-signature match, so it only fires where expected. Remove once qemu-arm
 * gains 32-bit clone3. */
struct clone_args_min { /* prefix of the kernel struct clone_args (all u64) */
    unsigned long long flags, pidfd, child_tid, parent_tid, exit_signal,
                       stack, stack_size, tls;
};

extern int __clone(int (*fn)(void *), void *stack, int flags, void *arg,
                   void *ptid, void *tls, void *ctid);

__attribute__((used)) static int
shim_clone3(struct clone_args_min *a, unsigned long size,
            int (*fn)(void *), void *arg) {
    (void)size;
    int flags = (int)(a->flags | a->exit_signal);
    void *stack_top = (void *)(unsigned long)(a->stack + a->stack_size);
    return __clone(fn, stack_top, flags, arg,
                   (void *)(unsigned long)a->parent_tid,
                   (void *)(unsigned long)a->tls,
                   (void *)(unsigned long)a->child_tid);
}

/* Encode `movw Rd,#lo16 ; movt Rd,#hi16` (Thumb-2 T3/T1) into 8 bytes, loading
 * the full 32-bit +val+ into register +rd+. */
static void emit_movw_movt(unsigned char *p, int rd, unsigned long val) {
    for (int hi = 0; hi < 2; hi++) {
        unsigned int imm16 = (val >> (hi * 16)) & 0xffff;
        unsigned int i = (imm16 >> 11) & 1, imm4 = (imm16 >> 12) & 0xf;
        unsigned int imm3 = (imm16 >> 8) & 0x7, imm8 = imm16 & 0xff;
        unsigned int hw1 = 0xf240 | (hi ? 0x80 : 0) | (i << 10) | imm4;
        unsigned int hw2 = (imm3 << 12) | (rd << 8) | imm8;
        p[hi * 4 + 0] = hw1 & 0xff; p[hi * 4 + 1] = (hw1 >> 8) & 0xff;
        p[hi * 4 + 2] = hw2 & 0xff; p[hi * 4 + 3] = (hw2 >> 8) & 0xff;
    }
}

/* Redirect the libc's __clone3 to shim_clone3 (an absolute Thumb branch via
 * movw/movt/bx). Returns 1 if the patch was applied. */
static int patch_clone3(unsigned long base) {
    /* push {r7}; movw r7,#435; svc 0 -- the wrapper's syscall site, little-endian */
    static const unsigned char sig[] = {0x80, 0xb4, 0x40, 0xf2, 0xb3, 0x17, 0x00, 0xdf};
    static const unsigned long OFFSET = 0xb695e; /* fixture-specific (libc-2.43-8c7af7f2) */
    unsigned char *site = (unsigned char *)(base + OFFSET);
    if (memcmp(site, sig, sizeof sig) != 0) {
        fprintf(stderr, "aletheia: clone3 hack signature mismatch; not applied\n");
        return 0;
    }

    unsigned long page = (unsigned long)site & ~0xfffUL;
    if (mprotect((void *)page, 0x2000, PROT_READ | PROT_WRITE | PROT_EXEC) != 0) {
        fprintf(stderr, "aletheia: clone3 hack mprotect failed\n");
        return 0;
    }

    unsigned long tgt = (unsigned long)&shim_clone3; /* Thumb bit already set */
    unsigned char patch[10];
    emit_movw_movt(patch, 12, tgt);                  /* movw ip; movt ip */
    patch[8] = 0x60; patch[9] = 0x47;                /* bx ip */
    memcpy(site, patch, sizeof patch);
    __builtin___clear_cache((char *)site, (char *)site + sizeof patch);
    fprintf(stderr, "aletheia: clone3->clone hack applied at %p\n", (void *)site);
    return 1;
}

/* Register file to load before jumping to the gadget (r0..r12, sp, pc). */
struct inj { unsigned int r[13]; unsigned int sp; unsigned int pc; };

/* Load the register file and branch to g->pc; bit0 of pc selects Thumb/ARM.
 * g is read through an absolute pointer, so moving sp first is safe. */
__attribute__((noreturn)) static void jump_inj(struct inj *g) {
    __asm__ volatile(
        "mov  r3, %0\n"
        "ldr  r0, [r3, #52]\n"   /* r0 = g->sp   */
        "mov  sp, r0\n"
        "ldr  lr, [r3, #56]\n"   /* lr = g->pc (target, Thumb bit set by caller) */
        "ldr  r0, [r3, #0]\n"
        "ldr  r1, [r3, #4]\n"
        "ldr  r2, [r3, #8]\n"
        "ldr  r4, [r3, #16]\n"
        "ldr  r5, [r3, #20]\n"
        "ldr  r6, [r3, #24]\n"
        "ldr  r7, [r3, #28]\n"
        "ldr  r8, [r3, #32]\n"
        "ldr  r9, [r3, #36]\n"
        "ldr  r10,[r3, #40]\n"
        "ldr  r11,[r3, #44]\n"
        "ldr  r12,[r3, #48]\n"
        "ldr  r3, [r3, #12]\n"   /* r3 last: it held the pointer */
        "bx   lr\n"
        :: "r"(g) : "memory");
    __builtin_unreachable();
}

/* Apply the plan and jump. Plan grammar (one directive per line):
 *   default benign|poison|null   fill for registers the plan doesn't set
 *   reg <n> s|l|b <hex>          r<n> = scratch+hex (s) | literal (l) | base+hex (b)
 *   mem <hex-off> <hex-val>      *(scratch+off) = scratch+val (a scratch pointer,
 *                                for a chained dereference like [[sp]]==NULL)
 *   sp <hex>                     sp = scratch + hex
 *   pc <hex>                     pc = base + hex
 *   thumb 1                      enter the gadget in Thumb state
 * Offsets are 32-bit two's-complement (a scratch_off may be negative). */
__attribute__((noreturn))
static void self_inject(unsigned long base, unsigned char *scratch, const char *plan) {
    struct inj g;
    unsigned int rv[13];
    char rset[13] = {0};
    unsigned long fill = (unsigned long)scratch + STRING_POOL;
    unsigned int sp = 0, pc = 0;
    unsigned long off;
    int thumb = 0, i;

    memcpy(scratch + COMMAND_POOL, "ls /", 5); /* the L2 command the gadget runs */

    if (getenv("ALETHEIA_CLONE3_HACK")) patch_clone3(base);

    char *buf = strdup(plan);
    for (char *line = strtok(buf, "\n"); line; line = strtok(NULL, "\n")) {
        unsigned int n;
        char kind;
        unsigned long v;
        if (sscanf(line, "reg %u %c %lx", &n, &kind, &v) == 3 && n < 13) {
            rv[n] = (unsigned int)(kind == 's' ? (unsigned long)scratch + v
                                 : kind == 'b' ? base + v
                                 : v);
            rset[n] = 1;
        } else if (sscanf(line, "mem %lx %lx", &off, &v) == 2) {
            /* A chained dereference (e.g. [[sp]]==NULL) needs a real pointer at
             * scratch+off, not just the zero-fill a single dereference relies on. */
            *(unsigned int *)(scratch + off) = (unsigned int)((unsigned long)scratch + v);
        } else if (sscanf(line, "sp %lx", &v) == 1) {
            sp = (unsigned int)((unsigned long)scratch + v);
        } else if (sscanf(line, "pc %lx", &v) == 1) {
            pc = (unsigned int)(base + v);
        } else if (strncmp(line, "default poison", 14) == 0) {
            fill = 0xDEAD0000;
        } else if (strncmp(line, "default null", 12) == 0) {
            fill = 0;
        } else if (strncmp(line, "thumb 1", 7) == 0) {
            thumb = 1;
        }
    }
    free(buf);

    for (i = 0; i < 13; i++) g.r[i] = rset[i] ? rv[i] : (unsigned int)fill;
    g.sp = sp;
    g.pc = thumb ? (pc | 1) : pc;
    jump_inj(&g);
}
#endif /* __arm__ */

/* Load base of the first mapping whose file basename starts with +name+, or 0.
 * When +path_out+ is non-NULL it receives that mapping's full file path. */
static unsigned long map_base_path(const char *name, char *path_out, size_t path_sz) {
    FILE *f = fopen("/proc/self/maps", "r");
    char line[1024];
    unsigned long base = 0;
    while (f && fgets(line, sizeof line, f)) {
        char *slash = strrchr(line, '/');
        if (slash && strncmp(slash + 1, name, strlen(name)) == 0) {
            base = strtoul(line, NULL, 16);
            if (path_out) {
                char *p = strchr(line, '/');
                size_t n = strcspn(p, "\n");
                if (n < path_sz) { memcpy(path_out, p, n); path_out[n] = 0; }
                else if (path_sz) path_out[0] = 0;
            }
            break;
        }
    }
    if (f) fclose(f);
    return base;
}

static unsigned long map_base(const char *name) {
    return map_base_path(name, NULL, 0);
}

/* Whether two files have identical contents (used to confirm the target IS the
 * already-loaded libc). */
static int files_identical(const char *a, const char *b) {
    FILE *fa = fopen(a, "rb"), *fb = fopen(b, "rb");
    int same = fa && fb;
    char ba[65536], bb[65536];
    size_t na, nb;
    while (same) {
        na = fread(ba, 1, sizeof ba, fa);
        nb = fread(bb, 1, sizeof bb, fb);
        if (na != nb || memcmp(ba, bb, na) != 0) { same = 0; break; }
        if (na == 0) break;
    }
    if (fa) fclose(fa);
    if (fb) fclose(fb);
    return same;
}

int main(int argc, char **argv) {
    if (argc < 2) {
        fprintf(stderr, "usage: %s <target-libc.so>\n", argv[0]);
        return 2;
    }

    void *scratch = mmap(NULL, SCRATCH_SIZE, PROT_READ | PROT_WRITE,
                         MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
    if (scratch == MAP_FAILED) {
        fprintf(stderr, "mmap failed\n");
        return 1;
    }

    /* dlopen the target to map it at a known base. This can fail when the target
     * is a full libc.so.6 that imports an ld.so-private symbol coupled only to
     * the PRIMARY libc (e.g. glibc >= 2.35's __nptl_change_stack_perm) -- such a
     * symbol can't be resolved for a dlopen'd SECONDARY libc. But a version-matched
     * sysroot links this stub against a libc byte-identical to the target, so the
     * target is ALREADY mapped as our primary libc; when its file matches the
     * loaded libc.so.6, fall back to that mapping instead of erroring. */
    char loaded[1024] = "";
    unsigned long libc_base = map_base_path("libc.so.6", loaded, sizeof loaded);
    void *h = dlopen(argv[1], RTLD_NOW | RTLD_LOCAL);
    if (!h && !(loaded[0] && files_identical(argv[1], loaded))) {
        fprintf(stderr, "dlopen failed: %s\n", dlerror());
        return 1;
    }

    /* The target's own mapping, or the loaded libc when the target == it (dlopen
     * deduped, or we fell back above). */
    const char *bn = strrchr(argv[1], '/');
    bn = bn ? bn + 1 : argv[1];
    unsigned long base = map_base(bn);
    if (!base) base = libc_base ? libc_base : map_base("libc.so.6");

    const char *outpath = getenv("ALETHEIA_STUB_OUT");
    if (outpath) {
        FILE *out = fopen(outpath, "w");
        if (out) {
            fprintf(out, "ALETHEIA_BASE=0x%lx\nALETHEIA_SCRATCH=%p\n", base, scratch);
            fclose(out);
        }
    }

    const char *plan = getenv("ALETHEIA_SELFINJECT");
    if (plan && *plan) {
#ifdef __arm__
        self_inject(base, (unsigned char *)scratch, plan); /* noreturn */
#else
        fprintf(stderr, "self-inject not supported on this arch\n");
        return 2;
#endif
    }
    aletheia_park();
    return 0;
}
