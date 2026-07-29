# Aletheia findings

Verification runs of one_gadget's aarch64 output against real, natively-executed
libc. Two run modes:

- **default (benign)** — registers the constraints don't govern point at readable
  zeroed scratch. Reproduces a gadget under favorable state.
- **`--strict` (poison)** — those registers are set to an unmapped address, so any
  *unlisted* dependency faults. This is the completeness test for the constraint list.

## Summary

| fixture | gadgets | benign | strict (poison) |
| --- | --- | --- | --- |
| aarch64-libc-2.43.so | 8 (posix_spawn) | 8 PASS | 8 PASS |
| aarch64-libc-2.24.so | 3 (execve)     | 3 PASS | 1 PASS, 2 FAIL |
| aarch64-libc-2.23.so | 3 (execve)     | 3 PASS | 1 PASS, 2 FAIL |

Every gadget launches a real, working `/bin/sh` under benign state (validated by the
shell running `ls /` and reproducing the host root). The 2.43 set is also complete
under poison. The strict failures were candidate one_gadget bugs (Findings 1 and 2), both fixed in
PR #323. With the fix, strict is **all PASS** across the
2.43/2.24/2.23 fixtures (one_gadget reports the reliable entry points, and the constraint
lists are complete).

## Level-1 sweep (every gadget)

With `--level 1`, one_gadget emits every gadget it finds (not just the top-scoring few). After
the PR #323 fixes, the full aarch64 sweep is:

| fixture | level-1 gadgets | PASS | EXEC* (promotable) | EXEC (hard) | FAIL |
| --- | --- | --- | --- | --- | --- |
| aarch64-libc-2.43.so | 28 | 27 | 1 | 0 | 0 |
| aarch64-libc-2.24.so | 8  | 8  | 0 | 0 | 0 |
| aarch64-libc-2.23.so | 11 | 9  | 2 | 0 | 0 |

**All 47 gadgets are verified usable — 44 PASS, 3 EXEC\*, zero unpromotable EXEC, zero FAIL.**
Every gadget reaches `execve("/bin/sh")` with a valid argv/envp; 44 are driven to run `ls /`
directly, and the other 3 are **promotable** (EXEC*).

Two argv shapes needed care to drive:

- **`sh -c <cmd>` (do_system / posix_spawn).** The command operand is a controllable register,
  so the harness points it at an `"ls /"` string. When the argv is `{"sh", "-c", $base+..., x21}`
  and that libc constant is `"--"`, the `--` merely ends `sh`'s option parsing, so the *next*
  operand (`x21`, controllable) becomes the command — point `x21` at `"ls /"` and `sh -c -- "ls /"`
  runs it. These now PASS directly.
- **`execve("/bin/sh", <reg>, ...)` (execvpe / 2.43 conditional).** The code writes an
  uncontrolled register as `argv[1]`, which the benign fill sets to a garbage-but-readable
  string `sh` treats as a script name. Nulling that register (which an attacker controls)
  terminates argv, so the shell is interactive and runs `ls /`. The harness proves this by
  retrying with uncontrolled registers nulled (reported EXEC*). The satisfier can't set that
  register itself because it isn't named in the constraints (it's argv content the code writes),
  so these stay EXEC* rather than PASS.

Strong empirical evidence that one_gadget's aarch64 level-1 output is sound: every gadget
reaches a real `/bin/sh` and yields a shell that actually runs commands.

## Finding 1 — missing constraint: sigprocmask `set` pointer must be readable

**Status: fixed** in PR #323 (emits `<set> == NULL` when
`set` isn't provably mapped). Under strict mode this fully fixes `0x3c92c`/`0x3d6d4`
(they now PASS). `0x3c934`/`0x3d6dc` gain the correct `x21 == NULL` too, but still FAIL
strict for a second, independent reason — see Finding 2.

The same defect existed on **all four architectures** (the `sigprocmask => {}` safe-call
entry is shared logic), so the fix is cross-arch: a shared `Processor#dispatch_safe_call`
marks `sigprocmask`'s `set` argument `:readable` and emits `<set> == NULL` when it isn't
provably mapped, applied via `arm_family.rb` (ARM/AArch64) and `x86.rb` (amd64/i386). On
amd64 the `set` register is `rbp`; on i386 it is a bare register too. The change is purely
additive at `level: 1` (no gadgets gained or lost across any fixture); at the default
`level: 0` it re-ranks — the harder entries (now carrying `set == NULL`) correctly fall
below the cleaner entry of the same `do_system`, which the default still shows.


**Gadgets:** `0x3c92c`, `0x3c934` (libc-2.24); `0x3d6d4`, `0x3d6dc` (libc-2.23).
Constraint form: `execve("/bin/sh", sp+0x58, environ)` with only
`writable: x19+…`, `writable: x20+0x4`, `x4 == NULL || {…}`.

**Symptom (strict mode):** SIGSEGV at `sigprocmask+28` (`ldr x19, [x1]`), before ever
reaching `execve`, with the fully-satisfied plan.

**Root cause (verified):** on the path from the gadget the code does
`mov x1, x21; bl sigprocmask` (`0x3c95c`/`0x3d704`). `x21` is never written on the
gadget path, so it is a precondition: it is `sigprocmask`'s `set` argument, which the
function dereferences unconditionally (`ldr x19, [x1]`, then `tst`). one_gadget lists
**no constraint on x21**. Setting `x21` to a readable pointer makes the gadget PASS
under poison — proving the omission (and only that) is the defect.

**Why one_gadget misses it:** the emulator's call handler treats `sigprocmask` as an
unconditionally-safe pass-through. In `lib/one_gadget/emulators/arm_family.rb`
(`inst_bl`), the checker is:

```ruby
checker = { 'sigprocmask' => {}, '__sigaction' => { 2 => :zero? } }
```

The empty hash for `sigprocmask` asserts no requirement on its arguments, but the real
function dereferences `set` (arg index 1). The correct model would require that arg to
be a readable pointer (emit e.g. `x21 is a readable pointer`, or a constraint that the
`set` argument is valid), analogous to how `__sigaction`'s arg 2 is required to be zero.

**Discriminator:** this is a genuine one_gadget imprecision, not a harness limitation —
the plan was complete and conflict-free, satisfied every listed constraint, and failed
only because of an input the constraint list does not mention. Impact: these gadgets are
less reliable than advertised; a return-to-one-gadget attempt with an arbitrary `x21`
crashes in `sigprocmask` instead of spawning a shell.

**Not affected:** `0x3c970`/`0x3d718` (`execve("/bin/sh", x22, environ)`) jump in *after*
the `sigprocmask` call, so they carry no such dependency and PASS under poison.

### Suggested fix (for review, not yet applied)
Model `sigprocmask`'s `set` argument in `arm_family.rb`'s `inst_bl` checker so a readable
pointer (or the appropriate NULL/validity condition) is emitted as a constraint, instead
of treating the call as argument-agnostic. Add a regression expectation to
`spec/one_gadget_aarch64_spec.rb` for the affected offsets. Per the batch-triage strategy,
this is filed here for joint review before a focused fix PR.

## Finding 2 — missing constraint: __sigaction `act` pointer (subtler)

**Gadgets:** `0x3c934` (libc-2.24), `0x3d6dc` (libc-2.23). **Status: fixed** in PR #323
(folded in with Finding 1's fix).

**Symptom (strict mode, with Finding 1 fixed):** SIGSEGV at `__libc_sigaction+36`
(`ldr x3, [x1], #8`), before `execve`.

**Root cause:** these entry points sit one instruction after the `add x1, x20, #8` that
sets up `__sigaction`'s `act` argument, so on this path `act` (x1) is an uncontrolled
incoming register that `__sigaction` dereferences. one_gadget requires `__sigaction`'s
`oldact` (arg 2) to be NULL but places no requirement on `act` (arg 1).

**Why it's subtler than Finding 1:** the sibling `0x3c92c` reaches `__sigaction` with
`act = x20+8`, and `x20` is already `writable`-constrained — so there `act` is valid and
must NOT be constrained to NULL. But the emulator processes the `__sigaction` call *before*
the later store that records `writable: x20`, so a naive "emit `act == NULL` when the base
isn't known-mapped" check would over-constrain `0x3c92c` (a false, over-tight constraint —
the opposite bug). A correct fix needs to consider constraints discovered later in the same
candidate (e.g. defer the pointer-safety check to post-emulation, cross-referencing the
final `writable` set), so it is left for a separate change.

**Resolution:** the `:readable` safe-call check was made *deferred* — resolved in
`Processor#finalize_deferred_reads` after emulation, when the full `writable:` set is known.
So `act = x20+8` (with `x20` writable) is recognised as mapped and left unconstrained, while
`act = x1` (bare, uncontrolled) gets `x1 == NULL`. That gives `0x3c934` its true, harder
constraint set, and `trim_gadgets` then drops it in favour of the dominating, reliable
`0x3c930` (`act` set up via `x20+8`). Aletheia `--strict` on libc-2.24 is now **3/3 PASS** —
the emitted set is complete. Same shape on libc-2.23 (`0x3d6dc` → `0x3d6d8`).

## Finding 3 — missing constraint: arm GOT-base register (environ gadgets)

**Gadgets:** `0x3afdc`, `0x543d2` (arm libc-2.43-8c7af7f2). **Status: candidate bug,
not yet fixed.**

**Constraint form:** `posix_spawn(..., environ)` — the envp argument is the libc global
`environ`. Listed constraints govern only the argv/attrp (e.g. `{"sh","-c","--",r9,...}
is a valid argv`, `r7 == NULL || (u16)[r7] == NULL`). **No constraint names the GOT base.**

**Symptom:** SIGSEGV at NULL before ever reaching `posix_spawn`, with the fully-satisfied
plan. Disasm at `0x3afdc`: `ldr r1, [pc, #416]` (GOT offset of `environ`), `ldr r1, [r6, r1]`
(GOT-base + offset), `ldr r3, [r1, #0]` — the last deref faults because `r6` isn't the GOT.

**Root cause (verified):** in ARM PIC, `environ` is reached through a GOT-base register that
glibc loads in the function prologue (`ldr rX, [pc]; add rX, pc`) — *outside* the gadget
window. The register is a precondition: it must hold `$base + got` (the libc `.got` base).
Setting it makes the gadget PASS (a real shell runs `ls /`):

| gadget | GOT-base reg | with `reg = $base + 0x12fe38` |
| --- | --- | --- |
| `0x3afdc` | `r6` (`ldr r1, [r6, r1]`) | PASS |
| `0x543d2` | `r7` (`ldr r2, [r7, r2]`) | PASS |

The register differs per gadget, so the constraint must name the right one.

**Why one_gadget misses it:** the arm fetcher already *detects* these registers and replays
their prologue setup so the emulator can resolve `environ` — `Fetchers::Arm#seed_got_registers`
seeds each GOT-base register with `$base + got` before emulating the candidate. But that
seeded assumption is never surfaced as a constraint. Contrast i386, whose fetcher derives the
GOT-base register from the (GOT-relative) `/bin/sh` pointer and emits
`"#{@base_reg} is the GOT address of libc"` (`Fetchers::I386#resolve`). arm should do the
same for the register(s) whose seeded GOT value flows into a resolved global.

**Discriminator:** a genuine imprecision, not a harness limitation — the plan satisfied every
listed constraint and failed only on an input the list omits. Impact: a return-to-one-gadget
attempt with an uncontrolled GOT-base register crashes before `posix_spawn` instead of
spawning a shell.

### Suggested fix (for review, not yet applied)
In `Fetchers::Arm`, record which seeded GOT-base register(s) were actually dereferenced to
resolve a global that appears in the final effect/constraints, and emit
`"<reg> is the GOT address of libc"` for each (mirroring i386, and reusing the existing
`Satisfier` support for that constraint). Add a regression expectation to the arm spec.

**Not the GOT issue:** the other level-1 posix_spawn FAILs on this fixture (`0x3b000`,
`0x3b002`, `0x3b004`, `0xa42c8`, `0xa4334`, `0xa4338`) do not reference `environ`; they need
the harness to build deeper argv/envp/arg0 scratch state (double derefs like argv `= [sp]`,
arg0 `= [sp+0x30]`) and are satisfier limitations, not one_gadget bugs.

## Finding 4 — imprecise constraint: frame-built argv hides an `argv[1]` requirement

**Gadgets:** `0xa3234`, `0xa3238`, `0xa3240`, `0xa32e8` (aarch64 libc-2.27, in `execvpe`).
**Status: candidate imprecision, not yet fixed.** Surfaced now that 2.27 is loadable under qemu.

**Constraint form:** `execve("/bin/sh", x29+0x40, <envp>)` with argv reported only as
`[x29+0x40] == NULL || x29+0x40 == NULL || x29+0x40 is a valid argv`. **No constraint on the
value that becomes `argv[1]`.**

**Symptom:** the gadget reaches `execve("/bin/sh", ...)` (so L0 passes, reported EXEC) but the
shell isn't drivable and isn't promotable. At the `execve`, the argv array is actually
`{"/bin/sh", "", NULL}` — a *non-NULL empty* `argv[1]` — so `sh` treats `""` as a script name
(`sh: 0: cannot open : No such file`) and exits.

**Root cause (verified):** on the `[x1] == 0` branch the code builds argv in the frame:
`add x1, x21, #0x7d0` (`"/bin/sh"`), then `stp x1, x0, [x29, #64]` — so `argv[0] = "/bin/sh"`,
`argv[1] = x0`, `argv[2] = NULL`. `argv[1]` is the incoming register `x0`; the benign fill makes
it a readable pointer to an empty string. Pinning `x0 = NULL` makes argv `{"/bin/sh", NULL}` and
the gadget **PASSes** (a real shell runs `ls /`). So the true precondition is `x0 == NULL` (or
`x0` a valid arg), which the listed constraints omit.

**Why one_gadget misses it:** the emulator tracks `sp`-relative stacks (for which it *does* emit
precise per-element argv constraints like `argv[1] == NULL || {...}`), but here argv is built at
`x29 + 0x40` off the *frame pointer*, which the candidate enters uninitialised. Writes into that
frame aren't tracked, so instead of `{"/bin/sh", x0, ...}` it falls back to the opaque
`x29+0x40 is a valid argv` — which is satisfiable by pointing the register at empty scratch even
though the code overwrites that memory. The `argv[1] = x0` requirement is lost.

**Discriminator:** not a harness limitation — the plan satisfied every listed constraint and the
gadget still yields a broken shell; adding the unlisted `x0 == NULL` fixes it. Impact: a
return-to-one_gadget with an uncontrolled `x0` gets a shell that immediately exits.

### Suggested fix (for review, not yet applied)
Track frame-pointer-relative argv construction (or recognise the `execvpe` rebuild) so the
emitted constraint names `argv[1]`'s source register — mirroring the existing `sp`-relative
argv handling (`x0 == NULL || {"/bin/sh", x0, ...} is a valid argv`). Harder than Finding 3:
it needs the emulator to model `x29`-relative writes, so filed for review before a fix.

## Reproduce

```
# benign (all PASS):
aletheia/bin/aletheia verify spec/data/aarch64-libc-2.24.so
# strict completeness test (2 FAIL):
aletheia/bin/aletheia verify --strict spec/data/aarch64-libc-2.24.so
```

Note: `aarch64-libc-2.27.so` aborts with SIGILL if `dlopen`ed under the glibc-2.43 host
loader, so verify it under qemu with a matched loader:

```
ALETHEIA_FORCE_QEMU=1 aletheia/bin/aletheia verify --level 1 spec/data/aarch64-libc-2.27.so
```

A per-version sysroot (the 2.27 ld.so + a stub cross-built against it) is fetched on demand;
the fixture then loads and its level-1 gadgets verify (12 PASS / 4 EXEC).
