# Adding an architecture backend

Aletheia is arch-parameterized. aarch64 is the reference backend and amd64 is fully wired
(driven under qemu-user on an aarch64 host). Adding another arch (i386, arm) is a new backend
object plus a cross-built stub — the satisfier, oracle, transport, and reporting are reused
unchanged.

## How the pieces fit

- **`lib/aletheia/arch/<name>.rb`** — the only arch-specific code: register model, ABI, and the
  `driver_model` hash serialized into the plan.
- **Transport** (`lib/aletheia/transport.rb`) is chosen automatically from the backend's `qemu`:
  `nil` -> run natively under `gdb`; a config hash -> run under `qemu-<arch> -g <port>` with a
  gdbstub and attach `gdb-multiarch`. No CLI flag — `Runner` maps the target ELF's machine to a
  backend via `ARCHES` and the backend decides the transport.
- **`driver.py`** is arch-neutral: it reads register names, `sp`/`pc`, and syscall numbers from
  the plan's `arch` block (`driver_model`), so the same driver serves every arch.
- **`park_stub`** is self-describing (pre-allocates scratch, prints its own libc base), so the
  driver needs no inferior `mmap` and no `/proc` access from a possibly-remote debugger — this is
  what makes the qemu-user path work.

## Backend object

Add `lib/aletheia/arch/<name>.rb` mirroring `arch/amd64.rb`, describing:

- `gprs` — assignable registers.
- `stack_regs` — registers naming a live stack address (an equality-to-NULL on `sp+imm` is
  unsatisfiable). Only the true stack pointer; a frame pointer the gadget lets the attacker
  control is a normal GPR.
- `sp` / `pc`.
- `native_on?(machine)` — whether the target runs natively on this host's `uname -m`.
- `normalize_reg(reg)` — fold a sub-register view onto its full register (aarch64 `w0 -> x0`,
  amd64 `eax -> rax`, `r8d -> r8`); setting the full register sets the low bits.
- `stub_binary` — the `park_stub_<arch>` this backend runs.
- `qemu` — `nil` for a native arch, else `{ 'bin', 'ld_prefix', 'gdb_arch' }` (the emulator,
  the sysroot providing the stub's own ld.so + libc, and the gdb architecture to select).
- `driver_model` — GPR list, `sp`, `pc`, `gdb_arch`, `sysno_reg`, `execve_syscalls`, and the
  execve arg registers (`path_reg`, `argv_reg`, `envp_reg`).

Register it in `Runner::ARCHES` keyed by `OneGadget::Helper.architecture`'s symbol.

## Stub

Cross-build the stub once (or after editing `park_stub.c`):

```
./build_stubs.sh        # native stub + any cross stub whose toolchain is installed
```

A foreign arch needs its cross-compiler (`gcc-<arch>-linux-gnu`) and, at run time, `qemu-user`
plus `gdb-multiarch`. `QEMU_LD_PREFIX` (the backend's `ld_prefix`) must point at a sysroot whose
`ld.so`/`libc.so.6` matches the stub's own arch — the cross toolchain's sysroot works because the
stub `dlopen`s the *target* fixture separately.

## Older foreign libcs (per-version sysroots)

The default cross sysroot only loads fixtures close to its own glibc version. An *older* libc
fails two ways: its init crashes under the newer `ld.so`, and the modern-toolchain stub needs
symbol versions the old libc lacks (e.g. i386 `dlopen@GLIBC_2.34`). Build a matching sysroot:

```
./build_sysroot.sh i386 2.27-3ubuntu1     # fetch that libc6 + libc6-dev, cross-build a stub
```

It fetches the fixture's `libc6`/`libc6-dev` `.deb`s (the fixtures come from ubuntu; the version
is in the fixture's `GNU C Library (Ubuntu GLIBC …)` string), extracts `sysroots/<arch>-<ver>/`
with the matching `ld.so`, and links `park_stub` against that libc.

The transport uses `sysroots/<arch>-<major.minor>/` for a fixture of that glibc version, and
**builds it on demand** when missing — but only for an arch that needs it (`version_strict?`, i.e.
i386, not amd64) and a Ubuntu-sourced fixture. So `sysroots/` (git-ignored) can be deleted anytime
to reclaim disk; the next verify rebuilds what it needs. `ALETHEIA_LD_PREFIX` / `ALETHEIA_STUB`
override manually. (Debian-sourced older fixtures would need their `.deb`s fetched differently —
not handled yet; the default cross sysroot covers the toolchain-matched version.)

## posix_spawn note

`do_system` gadgets fork a child that execs the shell. Natively, gdb follows the child and drives
it. Over a qemu-user gdbstub a single stub can't debug both fork sides, so the driver stays with
the parent and lets the child run free on the guest tty — the L2 `ls /` check on the pty is the
arbiter either way. The driver picks the mode from the transport (`connect == "run"`).

## Fixtures and expectations

amd64/i386 fixtures already live in `spec/data/libc-*.so`. Verify against those and record results
in `docs/FINDINGS.md`.

## Checklist

- [ ] `arch/<name>.rb` with the register/ABI model and `driver_model`.
- [ ] `qemu` config (or `nil`) and a cross-built `park_stub_<name>`.
- [ ] registered in `Runner::ARCHES`.
- [ ] a passing run on one straight-line execve gadget, then the full set.
- [ ] a negative control (a valid plan redirected to a non-shell offset) that FAILs.
- [ ] findings recorded.
