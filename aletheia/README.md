# Aletheia

Empirically verify that [one_gadget](https://github.com/david942j/one_gadget)'s gadgets
actually launch a shell on a real machine. Aletheia loads a real libc, jumps a live
process to a gadget offset with registers/stack crafted to satisfy that gadget's
constraints, and checks that a real `/bin/sh` runs `ls /` and reproduces the host root.

This is **dev-only verification tooling.** It lives outside `lib/` and `bin/` so it is not
part of the published gem.

## Status

Verifies aarch64 libc natively (this is the reference backend). Other architectures plug
in behind `Aletheia::Arch` — see `docs/ADDING-AN-ARCH.md`.

## Prerequisites

- An aarch64 host with `gdb` installed (native execution; no qemu needed for aarch64).
- Ruby (same as one_gadget: >= 3.3), run from the one_gadget repo so `../lib` is on the load path.
- The parking stub, built once:

```
cc -O0 -g -o aletheia/park_stub aletheia/park_stub.c -ldl
```

## Usage

```
# Verify every gadget in a libc (benign register defaults):
aletheia/bin/aletheia verify spec/data/aarch64-libc-2.43.so

# Completeness test: poison uncontrolled registers so unlisted
# dependencies fault (finds missing-constraint bugs):
aletheia/bin/aletheia verify --strict spec/data/aarch64-libc-2.24.so

# Restrict to specific offsets, machine-readable output:
aletheia/bin/aletheia verify --offset 0x4bc00,0x4bc04 --json spec/data/aarch64-libc-2.43.so
```

## Reading the result

Per gadget: `PASS` / `FAIL` / `SKIP`.

- **PASS** — the spawned shell listed the real root. This empirical result is the sole
  arbiter of a valid gadget; it does not depend on one_gadget's own interpretation.
- **FAIL** — a complete, satisfied plan still failed to yield a working shell. Under
  `--strict` this is a candidate one_gadget bug (usually a missing constraint). Use
  `discover.py` to find the faulting instruction (see `docs/DESIGN.md`).
- **SKIP** — the satisfier could not build a plan (a harness limitation, not a verdict).

Exit code is nonzero if any gadget FAILs.

See `docs/FINDINGS.md` for verified results and bugs, and `docs/DESIGN.md` for how it works.
