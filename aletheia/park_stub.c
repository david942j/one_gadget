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

#define SCRATCH_SIZE 0x10000
#define STRING_POOL  0x100  /* benign default: a readable, zero-filled scratch slot */
#define COMMAND_POOL 0x200  /* where the L2 "ls /" command is seeded (cf. satisfier) */

/* Break here to inject: libc is fully loaded and scratch is mapped. */
void aletheia_park(void) {
    for (;;) {
        pause();
    }
}

#ifdef __arm__
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
    int thumb = 0, i;

    memcpy(scratch + COMMAND_POOL, "ls /", 5); /* the L2 command the gadget runs */

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

/* Load base of the first mapping whose file basename starts with +name+, or 0. */
static unsigned long map_base(const char *name) {
    FILE *f = fopen("/proc/self/maps", "r");
    char line[1024];
    unsigned long base = 0;
    while (f && fgets(line, sizeof line, f)) {
        char *slash = strrchr(line, '/');
        if (slash && strncmp(slash + 1, name, strlen(name)) == 0) {
            base = strtoul(line, NULL, 16);
            break;
        }
    }
    if (f) fclose(f);
    return base;
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

    void *h = dlopen(argv[1], RTLD_NOW | RTLD_LOCAL);
    if (!h) {
        fprintf(stderr, "dlopen failed: %s\n", dlerror());
        return 1;
    }

    /* The target's own mapping, or the host libc when dlopen deduped the target
     * to the already-loaded system libc (target == system libc). */
    const char *bn = strrchr(argv[1], '/');
    bn = bn ? bn + 1 : argv[1];
    unsigned long base = map_base(bn);
    if (!base) base = map_base("libc.so.6");

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
