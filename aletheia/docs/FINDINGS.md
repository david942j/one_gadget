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
under poison. The strict failures are candidate one_gadget bugs (Findings 1 and 2). With
Finding 1's fix applied, strict results for 2.24/2.23 become 2 PASS, 1 FAIL (the remaining
FAIL is Finding 2).

## Finding 1 — missing constraint: sigprocmask `set` pointer must be readable

**Status: fixed** on branch `fix-sigprocmask-set-constraint` (emits `<set> == NULL` when
`set` isn't provably mapped). Under strict mode this fully fixes `0x3c92c`/`0x3d6d4`
(they now PASS). `0x3c934`/`0x3d6dc` gain the correct `x21 == NULL` too, but still FAIL
strict for a second, independent reason — see Finding 2.


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

**Gadgets:** `0x3c934` (libc-2.24), `0x3d6dc` (libc-2.23). **Status: open, needs review.**

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

## Reproduce

```
# benign (all PASS):
aletheia/bin/aletheia verify spec/data/aarch64-libc-2.24.so
# strict completeness test (2 FAIL):
aletheia/bin/aletheia verify --strict spec/data/aarch64-libc-2.24.so
```

Note: `aarch64-libc-2.27.so` cannot be loaded standalone on a glibc-2.43 host (dlopen
aborts with SIGILL), so it is currently out of scope; see the loader-fallback risk in the
project plan.
