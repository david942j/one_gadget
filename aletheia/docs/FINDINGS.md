# Aletheia findings

Verification runs of one_gadget's aarch64 output against real, natively-executed
libc. Two run modes:

- **default (benign)** — registers the constraints don't govern point at readable
  zeroed scratch. Reproduces a gadget under favorable state.
- **`--strict` (poison)** — those registers are set to an unmapped address, so any
  *unlisted* dependency faults. This is the completeness test for the constraint list.

Findings 7, 9 and 10 are missing from this document on purpose: they were bugs in the
harness rather than in one_gadget's output -- a gadget allowed to close the shell's own
stdin, a GOT-base register re-seeded from no evidence, and a libc matched to a sysroot by
file name -- and what is written up here is what verification found wrong with the
gadgets themselves.

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

### Fix applied (PR #323)
`sigprocmask`'s `set` argument is modelled in `arm_family.rb`'s `inst_bl` checker, emitting
`<set> == NULL` when it isn't provably mapped, instead of treating the call as
argument-agnostic. Regression expectations added to `spec/one_gadget_aarch64_spec.rb`.

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

**Gadgets:** `0x3afdc`, `0x543d2` (arm libc-2.43-8c7af7f2). **Status: fixed**, one_gadget#331.

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

### Fix applied (one_gadget#331)
`Fetchers::Arm` now records which seeded GOT-base register(s) were actually dereferenced to
resolve a global that appears in the final effect/constraints, and emits
`"<reg> is the GOT address of libc"` for each (mirroring i386, reusing the existing
`Satisfier` support for that constraint). Verified: both gadgets PASS with the fix applied
(Aletheia re-run after the code change). Locked in by `arm-libc-2.43-8c7af7f2` in
`spec/one_gadget_arm_spec.rb` (one_gadget#332).

**Not the GOT issue:** the other level-1 posix_spawn FAILs on this fixture (`0x3b000`,
`0x3b002`, `0x3b004`, `0xa42c8`, `0xa4334`, `0xa4338`) did not reference `environ`; they
were a **harness limitation, not a one_gadget bug** -- the satisfier couldn't build a
chained dereference (`argv=[sp]` needs `[[sp]] == NULL`, i.e. argv[0]=NULL, which requires
a real pointer at `[sp]`, not the zero-fill a *single* deref gets for free). Fixed by
`Satisfier#apply_deep_null` (see DESIGN.md's satisfier section); all 10 of this fixture's
level-1 gadgets now PASS, including these six.

## Finding 4 — imprecise constraint: frame-built argv hides an `argv[1]` requirement

**Gadgets:** `0xa3234`, `0xa3238`, `0xa3240`, `0xa32e8` (aarch64 libc-2.27, in `execvpe`).
**Status: fixed**, one_gadget#333. Surfaced once 2.27 became loadable under qemu
(`ALETHEIA_FORCE_QEMU=1`, see Known limitations).

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

### Fix applied (one_gadget#333)
Frame-pointer-relative stores are now tracked (mirroring x86's existing `bp_based_stack`,
added as a shared `arm_family.rb` facility so any arch can opt in; aarch64 enables it with
`x29`), so the emitted constraint names `argv[1]`'s source register:
`x0 == NULL || {"/bin/sh", x0, NULL} is a valid argv` — the same shape the `sp`-relative case
already had. Verified: all four gadgets went from EXEC to PASS under Aletheia. Also
harmonized a latent inconsistency: the `sp`-relative twin `0xa321c` already had the precise
form, so the trimmer now dedups the two into one gadget.

## Cross-arch strict-mode sweep

With the harness reliability bugs fixed (see DESIGN.md's "Harness reliability fixes") and
the deep-null satisfier capability in place, `--strict` was run on every arch's current
libc for the first time (previously only run on aarch64 2.24/2.23, where it found Findings
1/2). Near-total: 62 of 64 level-1 gadgets across five fixtures PASS clean (the other 2
are the known-promotable aarch64 EXEC and Finding 5 below).

| fixture | gadgets | result |
| --- | --- | --- |
| amd64 2.43 | 11 | 11 PASS |
| i386 2.43 | 6 | 5 PASS, **1 FAIL** (Finding 5) |
| i386 2.19 | 9 | 9 PASS |
| arm 2.43 | 10 | 10 PASS |
| aarch64 2.43 | 28 | 27 PASS, 1 EXEC (known-promotable, see the level-1 sweep above) |

## Finding 5 — missing constraint: an uncontrolled register clobbers a later NULL-checked stack slot

**Gadget:** `0xed234` (i386 libc-2.43-7a08e84a). **Status: candidate bug, not yet fixed.**
Found via the strict-mode sweep above; three sibling entries into the same shared tail
(`0xed237`, `0xed240`, `0xed300`) all PASS.

**Constraint form:** `execve("/bin/sh", ebp-0x28, [ebp-0x30])` with
`[[ebp-0x30]] == NULL || [ebp-0x30] == NULL || [ebp-0x30] is a valid envp` governing envp.
**No constraint mentions `ecx`.**

**Symptom (strict):** a fully-satisfied plan still FAILs -- `edx` (the syscall's real envp
argument) reads `0xDEAD0000` (the poison fill) instead of NULL at the `execve` syscall.

**Root cause (verified):** the candidate's first instruction is
`mov %ecx, -0x30(%ebp)` -- it writes the (uncontrolled, poisoned) register `ecx` into the
exact stack slot the envp constraint later requires to read zero. Later,
`mov (%edx), %ebx` / the shared tail at `0xed300`+ reloads envp from that same slot into
`edx` for the syscall. So `ecx`'s value *is* the syscall's envp, but nothing in the
constraint list says so. Setting `ecx = 0` (NULL) makes the gadget PASS -- a real shell
runs `ls /` (confirmed via direct register probe: `edx` reads `0x0` at the syscall instead
of `0xDEAD0000`, and the full oracle run reports PASS with L2 satisfied).

**Why one_gadget misses it:** `Fetchers::Base#check_envp` only inspects tracked stack
content (`get_corresponding_stack`) when the envp pointer *itself* is a bare stack address
(`deref_count.zero?`). Here envp is `[ebp-0x30]` -- a value **read from** the stack
(`deref_count == 1`, since execve's envp argument comes from dereferencing that slot), not
the stack address itself. `check_envp`'s stack branch requires
`lmda.deref_count.zero? && stack_register?(lmda.obj)`, which is false here (deref_count is
1), so it falls through to the generic "opaque pointer" fallback -- which doesn't inspect
*what* `x86.rb`'s `bp_based_stack` already knows is stored at that slot (the Lambda for the
unresolved register `ecx`) and so never proposes `ecx == NULL` as the real precondition.

**Discriminator:** not a harness limitation -- the plan was complete, conflict-free, and
fully satisfied every listed constraint; it failed only on an input (`ecx`) the constraint
list never mentions. Impact: a return-to-one_gadget with an uncontrolled `ecx` reaches
`execve("/bin/sh", ...)` with a garbage `envp` pointer instead of the advertised NULL.

### Suggested fix (for review, not yet applied)
Extend `check_envp` (and likely `check_argv`'s analogous stack-lookup, `check_stack_argv`,
for the same shape on the argv side) to also inspect tracked stack content one level deeper
when the pointer itself is a single dereference of a stack-relative expression -- i.e.,
when `Lambda.parse(envp_ptr).deref_count == 1` and the *underlying* address is stack-relative,
look up `get_corresponding_stack`'s content at that slot. If the tracked content is an
unresolved register (not a concrete value), emit `<that register> == NULL || ...` instead of
the opaque double-deref form. This is the same class of gap as Finding 4 (frame-relative
writes existing but not being surfaced as constraints) applied to `bp_based_stack` reads
instead of `x29`-relative writes.

## Finding 6 — imprecise constraint: an untracked write through an "incoming" register hides an argv-content requirement

**Gadgets:** `0xc7a40` (aarch64 libc-2.43, `execve("/bin/sh", x4, x6)`); `0x9b9e4`
(aarch64 libc-2.23, `execve("/bin/sh", x1, x20)`); `0x9bc5c` (aarch64 libc-2.23,
`execve("/bin/sh", x0, x20)`). **Status: fixed**, by the work Finding 8 describes
(#375, consolidated by #378), rather than by the plan sketched at the end of this
section. All three now name the register that plan was written to expose: `0xc7a40`
reports `x0 == NULL || {"/bin/sh", x0, NULL} is a valid argv`, where it once said
nothing about `x0` at all, and the 2.23 pair name `x23`. The section is kept as
written, because its reasoning is what the fix was measured against -- see Finding 8
for why the shape it proposed was not the shape that worked. All three are the
"3 EXEC*" already counted in the Level-1 sweep summary above (found before this
investigation named the mechanism); this documents *why* they're EXEC* and what a
real fix would need.

**Severity, and how this differs from Findings 1/3/5:** those were true false positives --
a *fully satisfied* plan still crashed before ever reaching a shell. Here, the gadget
genuinely **does** reach `execve("/bin/sh", ...)` and spawn a real shell (L0 passes, a
process image gets replaced) under every listed constraint; the gap is that the shell
isn't reliably *interactive* unless an unlisted register also happens to be NULL. Aletheia
already flags this honestly as EXEC* (promotable under attacker control), not PASS -- so
no one is misled into thinking these gadgets are unconditionally safe. It's the same
*class* of gap as Finding 4 (a real precondition for reliable use isn't surfaced), not the
same severity as Findings 1/3/5.

**Constraint form (0xc7a40):** `writable: x4`, `x2 == 0x1`,
`[x4] == NULL || x4 == NULL || x4 is a valid argv`, envp similarly on `x6`. **No mention of `x0`.**

**Root cause (verified):** the candidate's own code writes the argv array through `x4`:
```
c7a40: adrp x5, ...
c7a44: add  x7, x5, #0x258   ; x7 = "/bin/sh" pointer
c7a48: stp  x7, x0, [x4]     ; argv[0] = x7, argv[1] = x0
...
c7a64: bl   execve
```
`argv[1]` is the **uncontrolled register `x0`**, written moments before the call. Under
benign fill `x0` is a readable-but-garbage pointer (not NULL), so `sh` treats it as a
script filename and exits non-interactively -- exactly the "reaches a shell but isn't
drivable" EXEC signature. Confirmed empirically: setting **only** `x0 = NULL` (nothing
else touched) flips the result to PASS with full L2. The other two gadgets are the
identical shape (`x1`/`x0` as the argv pointer, an adjacent register as the untracked
`argv[1]` write).

**Why one_gadget misses it:** `x4` (or `x1`/`x0` in the siblings) is set to its real value
(`sp`, in `0x9b9e4`'s case -- see below) **outside** the analyzed candidate window; one_gadget's
fetcher does a backward, per-candidate walk, so within `0xc7a40`'s own window `x4` is just an
opaque "incoming register" (`Lambda.new('x4')`, unresolved). The emulator's write-tracking
(`sp_based_stack`, and since Finding 4, a named frame-pointer `bp_based_stack`) is keyed to
exactly two *special-cased* registers. A write through any *other* register --
`stp x7, x0, [x4]` here -- falls into the generic `add_writable` path, which records "x4
must be writable" but discards *what* got written, so `argv[1]`'s true source (`x0`) is
invisible by the time the fetcher resolves the call's arguments.

(Verified this isn't secretly a "the window should include the assignment" case: in
`0x9b9e4`'s sibling window, `x1` really is set via `mov x1, sp` one instruction before the
window starts -- if that instruction were in-window, the *existing* sp-tracking would
already get this right. It's specifically the window boundary that hides it, not a gap in
the sp-tracking itself.)

**Discriminator:** an imprecision, not a false positive (see Severity above) -- but the
constraint list still doesn't name the real precondition for a reliably-interactive shell.

### Suggested fix (for review, not yet applied -- larger than Findings 4/5)
Generalize write-tracking from the two special-cased registers (`sp`, and the named frame
pointer) to *any* register: a per-register-name write history (`Hash.new { |h,r| h[r] = {} }`),
populated by every `str`/`stp`, consulted the same way `check_argv`/`check_envp` already
consult `sp_based_stack`/`bp_based_stack`. The added complexity Findings so far haven't
needed: **invalidation**. `sp`/frame-pointer are safe to track globally because they're
essentially never reassigned to something else mid-function; an arbitrary register can be
(`mov x4, x9` later in the same window would make old `x4`-keyed entries stale and wrong to
reuse). Register writes happen at several call sites across each arch's emulator (`inst_mov`,
`inst_add`, `inst_adrp`, `inst_ldr`, post-index writeback), not one chokepoint, so a safe
implementation needs either routing all of them through a shared setter that clears that
register's write history on reassignment, or an equivalent invalidation hook. Cross-arch
(aarch64.rb, arm.rb, x86.rb all have their own register-write sites). Given the severity is
"imprecise, not false-positive" and all three known instances are already correctly flagged
EXEC* (not silently trusted), this is lower urgency than Findings 1-5 were -- worth doing for
completeness, but with real design/review needed before implementation given the
cross-cutting change and the new invalidation-correctness requirement.

## Finding 8 -- imprecise constraint: argv built through a pointer no register names

**Gadgets:** `0xc18cd`, `0xc1b3d` (amd64 libc-2.19) and `0xcc27d`, `0xcc4c0` (amd64
libc-2.23), each `execve("/bin/sh", <a derived pointer>, r12)`. **Status: fixed** (#375,
consolidated by #378). Found 2026-08-11; these were the last four EXEC verdicts in the
corpus.

**Signature:** EXEC, not FAIL -- the gadget reaches a real shell, but the shell is not
drivable, the same signature as Finding 6.

**Root cause (verified):** the candidate builds the argv array in place, through a
pointer it derives rather than one a register names:

```
c18cd: and    rsi,0xfffffffffffffff0    ; the array's base -- no register holds it
c18d1: lea    rax,[rip+0xbafeb]         ; rax = "sh"
c18d8: cmp    r14d,0x1
c18dc: mov    QWORD PTR [rsi+0x8],r15   ; argv[1] = r15, an incoming register
c18e0: mov    QWORD PTR [rsi],rax       ; argv[0] = "sh"
...
       call execve
```

The emulator tracked writes under two special-cased bases, `sp` and the named frame
pointer. A store through `(rsi & ~0xf)` -- or through `[rbp-0x48]`, which is `0xc1b3d`'s
shape -- matched neither, so it fell to the generic `add_writable` path, which records
*that* the address must be writable and discards *what* was written. argv then rendered
as the opaque `[ptr] == NULL || ... is a valid argv`, whose first disjunct is one the
gadget's own store to `argv[0]` immediately overwrites, while the real requirement --
`argv[1]` holding an uncontrolled incoming register -- was never stated at all.

**The fix, and why it is not the one Finding 6 proposed:** Finding 6 asked for a write
history keyed by *register name*, and correctly identified invalidation as the hard part:
a later `mov x4, x9` must not let stale `x4` entries be read back. Keying by the *value*
the base renders as dissolves that problem, because a reassigned register simply names a
different value and nothing goes stale. Three pieces landed in #375, all cross-arch:

- `Lambda.parse` reading back its own operation rendering. Before it,
  `(rsi & 0xff..f0)` re-parsed as `rsi+0xff..f0`, and `(rsp+0xf & ...)` raised --
  silently dropping candidates.
- `Processor#value_based_stack`, the write history keyed by that rendering.
- `Processor#resolve_address`, one rule for where an address lands in tracked memory,
  replacing the scattered `get_corresponding_stack(x.obj)` + `x.immi` pairs.

**A trap worth keeping:** the `Lambda` representation is asymmetric. `[[X]]` collapses
onto `X` with a deref count of 2, while `[[X]+8]` nests. Call sites that guarded on
`deref_count == 1` therefore dropped the zero-offset store without a word. Route an
address through `resolve_address` rather than adding another depth guard.

**After the fix:** strict level 2 reached **1163 PASS, 0 EXEC, 0 FAIL, 0 SKIP** over all
21 fixtures, and six previously-dropped `rsp`-based siblings appeared -- better gadgets,
since their writable precondition is the stack itself. `0xc18cd` now reports
`r15 == NULL || {"sh", r15, [(rsi & 0xff..f0)+0x10], ...} is a valid argv`.

#378 then collapsed `sp_based_stack`, `bp_based_stack`, `reg_based_stack` and
`value_based_stack` into one store keyed by how the base renders, having measured that
the differences between them did nothing: `get_corresponding_stack` never saw an offset
expression across 53k calls, and the identity guard only ever discarded a history that
was still good, fragmenting the writes of a post-increment store loop.

## Finding 11 -- missing constraint: a scaled-index write into the array the gadget passes


**Gadgets:** `0xb5718`, `0xb571c`, `0xb571e` (riscv64 libc-2.39,
`posix_spawn(sp+0x44, "/bin/sh", [sp+0x30], 0, sp+0x50, [sp+0xd0])`), level 2 only.
**Status: fixed.** Found 2026-08-29, the first finding riscv64 produced -- and only once
the satisfier could plan these gadgets at all: they had been SKIPped, so nothing had ever
run them.

**Signature:** PASS benign, FAIL strict -- the constraint list is incomplete.

**Root cause (verified):** glibc copies `environ` into a fresh array in the `posix_spawn`
path, and the window writes an entry into it through a scaled index:

```
b571e: ld   a4,208(sp)     ; a4 = the envp base, [sp+0xd0]
b5720: slli a5,a5,0x3      ; index * 8
b5722: add  a5,a5,a4
b5724: sd   s8,0(a5)       ; envp[index] = s8
...
b5770: jal  posix_spawn    ; envp = [sp+0xd0]
```

one_gadget required the *address* to be writable but said nothing about the *value*, and
still described the array as `[[sp+0xd0]] == NULL || ... is a valid envp` -- a claim its own
store invalidates. Under poison `s8` is an unmapped pointer, `execve` fails EFAULT and no
shell runs. **Pinning `s8 = 0` by hand turns the strict run into a PASS**, which is the
proof.

The emulator was not losing the value: `resolve_address` keys such a write under a base
named `((a5 << 0x3) + [sp+0xd0])`, which nothing ever reads back. The fix records a store
whose address is an *operation* and lets the argv/envp resolver ask what was written
through a base built from the array pointer, stating each as
`s8 == NULL || readable: s8`. Operands are compared structurally rather than as text --
matching by substring finds `x3` inside `x30` and constrains unrelated aarch64 gadgets.

**Not the cause, though it is the loudest thing in the log:** the parent aborts with
`free(): invalid pointer` at `b577a`, because the plan points `[sp+0xd0]` at scratch rather
than the heap the code frees. That is survivable -- `posix_spawn` has vfork semantics, so
the child has already exec'd -- and with `s8` pinned the same abort still yields a PASS.

**Neighbours are correct:** `0xb5720`/`0xb5722`/`0xb5724` take the destination from a caller
register, so their store lands wherever the caller points it, not necessarily in the array.

**After the fix:** riscv64 level 2 is **171 PASS, 0 FAIL, 0 SKIP**, and no other
architecture's output changes at any level.

## Finding 12 -- missing constraint: a GOT base register the window reloads from its own frame

**Where:** mipsel-libc-2.36 `0x4b3d8`, `0x4b424` (both `posix_spawn`). Found the first
time MIPS was verified, 2026-09-02. **Fixed** -- one_gadget now *states* the slot as a
precondition. Refusing them, as this finding first proposed, was measured to cost 98
windows (28 raw gadgets) across the fixture, every one restoring from the same slot
`24(sp)` -- so a single extra constraint recovers them all, and they verify.

o32 code is PIC through `gp`, and every gadget on the architecture therefore carries
`gp is the GOT address of libc`. But the ABI also has the *caller* restore `gp` after
each call, because the callee establishes its own:

```
4b3e0: jalr t9 <posix_spawnattr_init>
4b3e4: move a0,s1          ; delay slot
4b3ec: lw   gp,24(sp)      ; gp reloaded from the frame
4b3f0: lw   t9,-31648(gp)  ; SIGSEGV -- reads the GOT through whatever that slot held
```

From `0x4b3ec` on, the window reaches the GOT through `[sp+0x18]`, a slot nobody sets
up. one_gadget still named the following call `<posix_spawnattr_setsigmask>` because the
fetcher pairs `lw t9,off(gp)` with `jalr t9` in the *text*, taking `gp` to be the GOT
base throughout. So the gadget was reported as though it reached `posix_spawn`, while a
caller meeting every stated constraint faults at `0x4b3f0`.

Aletheia said so plainly: `l0=false` with `SIGSEGV at base+0x4b3f0`, and the emulator's
own state confirms the cause -- both failing gadgets end with `gp = [sp+0x18]`, while
all six that pass end with `gp = gp`.

**The fix** states what the window really needs: `Fetchers::Mips#resolve` adds
`[sp+0x18] is the GOT address of libc` beside the register's own constraint. The harness
learned to arrange it -- a GOT constraint may now name a stack slot as well as a register,
and the driver resolves a libc address written into memory.

## Finding 13 -- wrong gadget: a window that follows a branch it never executed

**Where:** mipsel-libc-2.36 `0x722a4` (`posix_spawn`), found by the level-2 strict
scan, 2026-09-03. **Fixed** -- one_gadget now refuses these.

An instruction after a branch runs whether or not the branch is taken, so it is a
legitimate place to enter a gadget. What a gadget entering there cannot do is *follow*
that branch, which never executed. one_gadget did:

```
722a0: <branch to 722d0>
722a4: sw v0,4(s2)        ; the delay slot -- the gadget's entry
722d0: lw v0,-26436(gp)   ; where one_gadget continued: through the branch above
```

Entering at `0x722a4` really falls through to `0x722a8`, and four instructions later
walks into `jalr t9` on an uncontrolled register. Aletheia found it exactly there:
`SIGSEGV at base+0x722a8`, with `l0=false` -- and it failed unpoisoned too, so it was
never about a missing precondition, it was the wrong path.

The cause is on the harness's side of the fence in one_gadget: MIPS attributes a
branch's edge to its delay slot, because that is the last instruction to run before
control transfers. That is right for a path arriving *through* the branch and wrong for
one starting *at* the slot. `Fetchers::Mips#executed_windows` now refuses a window whose
second line is not the next instruction along -- which is exactly the shape of a window
that took a branch it skipped.

**All 61 MIPS gadgets verify** after this and Finding 14: 45 for the glibc fixture and 8
for each musl one, level 2, strict.

## Finding 14 -- wrong gadget: a window opening on a call it never set up

**Where:** mipsel-libc-2.36 `0x4b3e0`, `0x4b3f4`, `0x4b408`, `0x4b41c` (all
`posix_spawnattr_*`), found by the level-2 strict scan, 2026-09-03. **Fixed** -- one_gadget
now refuses these.

This arch reaches libc through `t9`, and one_gadget names a call by pairing the
`lw t9,off(gp)` that fills it with the `jalr t9` that uses it -- in the *text*. A window
that starts at the call left that load behind, so `t9` holds whatever the caller happened
to leave there, while the gadget is printed as though it called `posix_spawnattr_init`
(and its safe-call requirements were applied on that basis).

Nothing is lost by refusing rather than constraining: the caller would have to put a libc
address in `t9` anyway, which is the whole of what the gadget offers, and the window one
instruction earlier loads it itself and is the better answer.

Same root cause as Finding 12 -- a name taken from the disassembly text and used where the
window never established the value. That one is stated as a constraint because the slot it
names is ordinary attacker-controlled stack; this one is refused because the requirement
*is* the gadget.

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
