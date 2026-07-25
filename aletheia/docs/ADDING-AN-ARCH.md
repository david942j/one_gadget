# Adding an architecture backend

Aletheia is arch-parameterized; aarch64 is the reference backend. Adding another (amd64
shown here) is a new backend object plus small driver tweaks — the satisfier, oracle, and
reporting are reused unchanged.

## 1. Backend object

Add `lib/aletheia/arch/amd64.rb` mirroring `arch/aarch64.rb`, describing:

- `gprs` — assignable registers (`rax, rbx, rcx, rdx, rsi, rdi, rbp, r8..r15`).
- `stack_regs` — `%w[rsp rbp]` (an equality-to-NULL on `rsp+imm` is unsatisfiable).
- `sp` / `pc` — `'rsp'` / `'rip'`.
- `native_on?(machine)` — `machine == 'x86_64'`.
- `gdb_reg(name)` — `"$#{name}"`.

Register it in `Runner::ARCHES` and select it by the target's ELF machine (or a CLI flag).

## 2. Driver

`driver.py` is mostly arch-neutral (mmap, maps parsing, plan application). The
arch-specific bits are the register names in the fill loops and `sp`/`pc`. Parameterize the
GPR list and stack/pc names from the plan (pass them through from the backend) instead of
hardcoding `x0..x30`/`sp`. The `catch syscall execve execveat` + `ls /` oracle is identical.

## 3. Execution transport

- **Native**: if the host arch matches the target (amd64 libc on an amd64 host), it runs
  directly, exactly like aarch64 here.
- **qemu-user** (foreign target, e.g. amd64 libc on this aarch64 box): run `park_stub` +
  gdb under `qemu-x86_64` with a gdbstub, or `qemu-x86_64 -g <port>` and
  `gdb -ex 'target remote'`. Select via a `--qemu` flag. The satisfier/oracle don't change.

## 4. Fixtures and expectations

amd64 fixtures already live in `spec/data/libc-*.so`. Verify against those; add results to
`docs/FINDINGS.md`. The amd64 effect ABI (args in `rdi, rsi, rdx, rcx, r8, r9`) drives which
registers the satisfier pins for pointer args — encode that in the backend.

## Checklist

- [ ] `arch/<name>.rb` with the register model.
- [ ] `driver.py` GPR/sp/pc parameterized from the backend.
- [ ] execution transport (native and/or qemu) wired to a flag.
- [ ] a passing run on one simple gadget (the amd64 analogue of M1), then the full set.
- [ ] findings recorded.
