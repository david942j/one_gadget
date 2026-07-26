# Aletheia

Empirically verify that [one_gadget](https://github.com/david942j/one_gadget)'s gadgets
actually launch a shell on a real machine. Aletheia loads a real libc, jumps a live
process to a gadget offset with registers/stack crafted to satisfy that gadget's
constraints, and checks that a real `/bin/sh` runs `ls /` and reproduces the host root.

This is **dev-only verification tooling.** It lives outside `lib/` and `bin/` so it is not
part of the published gem.

## Status

Verifies aarch64 libc natively (the reference backend) and amd64 libc under qemu-user. The
backend is picked automatically from the target ELF's machine; other architectures plug in
behind `Aletheia::Arch` — see `docs/ADDING-AN-ARCH.md`.

## Prerequisites

- Ruby (same as one_gadget: >= 3.3), run from the one_gadget repo so `../lib` is on the load path.
- `gdb` for native verification (the host's own arch).
- For a foreign target (e.g. amd64 libc on an aarch64 host): `qemu-user`, `gdb-multiarch`, and
  the target's cross-compiler (`gcc-<arch>-linux-gnu`). No flag — a foreign target auto-selects
  the qemu transport.
- The parking stub(s), built once (native + any cross stub whose toolchain is installed):

```
aletheia/build_stubs.sh
```

## Usage

```
# Verify the top (level-0) gadgets of a libc (benign register defaults):
aletheia/bin/aletheia verify spec/data/aarch64-libc-2.43.so

# amd64 target on an aarch64 host runs under qemu-user automatically:
aletheia/bin/aletheia verify --level 1 spec/data/libc-2.23-*.so

# Verify EVERY gadget one_gadget finds (level 1):
aletheia/bin/aletheia verify --level 1 spec/data/aarch64-libc-2.43.so

# Completeness test: poison uncontrolled registers so unlisted
# dependencies fault (finds missing-constraint bugs):
aletheia/bin/aletheia verify --strict spec/data/aarch64-libc-2.24.so

# Restrict to specific offsets, machine-readable output:
aletheia/bin/aletheia verify --offset 0x4bc00,0x4bc04 --json spec/data/aarch64-libc-2.43.so
```

## Reading the result

Per gadget: `PASS` / `EXEC` / `FAIL` / `SKIP`.

- **PASS** — the spawned shell actually ran `ls /` and listed the real root (L2). The
  strongest signal; it does not depend on one_gadget's own interpretation.
- **EXEC** — the gadget reached `execve("/bin/sh")` with a valid argv/envp (L0), but the
  harness could not drive `ls /` through this particular shell (e.g. a fixed `-c` command
  baked into libc). The gadget works; only the L2 drive is inconclusive. Not a failure.
- **EXEC\*** (promotable) — an EXEC gadget that becomes a full L2 PASS once the *uncontrolled*
  register the code writes as `argv[1]` is nulled (which an attacker controls). Effectively a
  usable gadget; the harness proves it by retrying with uncontrolled registers nulled.
- **FAIL** — a complete, satisfied plan reached neither a shell nor any output. Under
  `--strict` this is a candidate one_gadget bug (usually a missing constraint); use
  `discover.py` to find the faulting instruction (see `docs/DESIGN.md`).
- **SKIP** — the satisfier could not build a plan (a harness limitation, not a verdict).

Exit code is nonzero only if some gadget FAILs (EXEC and SKIP do not).

See `docs/FINDINGS.md` for verified results and bugs, and `docs/DESIGN.md` for how it works.
