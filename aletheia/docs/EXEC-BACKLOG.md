# EXEC backlog (closed)

`EXEC` means the gadget **reached `execve`/`posix_spawn`** but the level-2 oracle
never got a shell to run `ls /`. Unlike `SKIP` (no plan could be built) an EXEC
run proves the gadget works up to the exec; what's missing is a shell we can
drive. These were worked through one category at a time, the way the SKIP
categories were.

The backlog is empty. The strict level-2 sweep over all 21 fixtures is
**1163 PASS / 0 EXEC / 0 FAIL / 0 SKIP**: every gadget one_gadget reports, on
every architecture, drives a real interactive shell under poisoned registers.

## What emptied it

Three causes, in the order they were found. The first two were the harness
observing badly; the third was a real one_gadget imprecision.

**Empty argv from the cheap NULL branch.** A constraint like
`[rsp+0x50] == NULL || {[rsp+0x50], ...} is a valid argv` has two satisfiable
disjuncts, and the satisfier took the cheaper one -- yielding a shell with no
`argv[0]`, which execs fine but gives the pty nothing to drive. Fixed by
preferring the array branch when the operand being constrained is the exec's
own argv, and by teaching the satisfier the five argv shapes a shell actually
accepts.

**The harness closing the shell's own stdin.** 122 of the remaining 142. A
gadget calling `close(<unconstrained descriptor>)` had that descriptor read as
0, so the spawned shell lost the pty it was supposed to be driven through. The
descriptor is the caller's to choose, so one_gadget now says so (a `caveats`
line) and the harness plans a spare one. A word-vs-dword plan write, which
zeroed an adjacent field, hid 20 more behind the same symptom.

**argv built through a pointer no register names.** The last 4. A candidate that
rounds a pointer down (`and rsi, ~0xf`) or loads one from its frame
(`mov rax, [rbp-0x48]`) and then writes argv in place had those stores go
untracked, because the emulator keyed write history to register names only. The
argv fell back to the opaque `[ptr] == NULL || ... is a valid argv`, whose first
disjunct the gadget's own store to `argv[0]` overwrites, while the real
requirement -- `argv[1]`, an incoming register -- went unstated. Fixed by giving
a derived pointer a write history of its own; see
`Processor#value_based_stack` / `#resolve_address`.

## Method

Same loop as the SKIP work: categorise by the *first* thing that blocks
observation, fix the largest category, re-sweep, re-categorise. A category
splits once its top blocker is removed -- each of the three above was invisible
until the one before it was gone.
