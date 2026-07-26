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

/* Break here to inject: libc is fully loaded and scratch is mapped. */
void aletheia_park(void) {
    for (;;) {
        pause();
    }
}

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
    aletheia_park();
    return 0;
}
