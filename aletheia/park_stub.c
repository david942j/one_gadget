/*
 * park_stub — load a target libc and park, so a debugger can hijack a fully
 * initialized thread to test a one_gadget candidate.
 *
 * Usage: park_stub <path-to-target-libc.so>
 *
 * It dlopen()s the target, prints its load base and useful markers on stderr,
 * then parks in a side-effect-free loop. At the park point libc relocation /
 * TLS bring-up is complete and `environ` is populated, so a debugger can set
 * pc = base + gadget_offset with crafted registers/stack and let it run.
 *
 * Build (once, ahead of time):
 *   cc -O0 -g -o park_stub park_stub.c -ldl
 */
#include <dlfcn.h>
#include <stdio.h>
#include <unistd.h>

int main(int argc, char **argv) {
    if (argc < 2) {
        fprintf(stderr, "usage: %s <target-libc.so>\n", argv[0]);
        return 2;
    }
    void *h = dlopen(argv[1], RTLD_NOW | RTLD_GLOBAL);
    if (!h) {
        fprintf(stderr, "dlopen failed: %s\n", dlerror());
        return 1;
    }
    fprintf(stderr, "PARK_STUB_PID=%d HANDLE=%p\n", (int)getpid(), h);
    fprintf(stderr, "PARK_STUB_READY\n");
    fflush(stderr);
    /* Park: re-enterable, no side effects. The debugger breaks here. */
    for (;;) {
        pause();
    }
    return 0;
}
