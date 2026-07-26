# Aletheia design

For a future maintainer (human or agent) picking this up cold. Read this, then
`FINDINGS.md`, then the source under `lib/aletheia/`.

## What is being verified

one_gadget derives each gadget's `offset`, `effect`, and `constraints` by *static*
emulation. Aletheia checks the claim empirically: if you jump to `base+offset` with state
that satisfies the constraints, does a working shell actually start?

## The pipeline

```
bin/aletheia
  -> Runner (lib/aletheia/runner.rb)
       enumerate gadgets:  OneGadget.gadgets(file:, force_file:true, details:true)
       for each gadget:
         Satisfier (lib/aletheia/satisfier.rb)  constraints -> injection Plan (JSON-able)
         Oracle    (lib/aletheia/oracle.rb)     run the plan, decide PASS/FAIL
                     |
                     v
   gdb -nx -batch -x driver.py --args park_stub <libc.so>   (on a pty)
     driver.py (gdb-Python):
       break at pause (libc fully initialized), read load base from /proc/pid/maps
       mmap zeroed scratch; fill uncontrolled regs (benign or poison); apply plan regs;
       set sp into scratch; set pc = base+offset; follow-fork child; continue
     Oracle drives the pty: writes `ls /` + `exit`, validates output vs Dir.children('/')
```

`park_stub.c` `dlopen`s the target libc and parks in `for(;;) pause();`. Parking after
init means relocations/TLS are done and `environ` is populated, and we hijack a thread
whose state is disposable — we overwrite pc/sp/regs and point sp at fresh scratch, so we
never corrupt the loader.

## The oracle: layered L0 + L2

`driver.py` runs the injected gadget and reports two signals:

- **L0** (deterministic): the gadget reaches `execve("/bin/sh")` with a readable argv/envp.
  A straight-line `execve`/`execl` stops at the syscall entry, where the `"/bin/sh"` path
  and pointers are checked directly. A `posix_spawn` execs in a vforked child that runs
  straight through to the new image, so there L0 instead confirms `/proc/pid/exe` is a shell.
- **L2** (the golden signal): the spawned shell actually ran `ls /` over a pty and the output
  matches the live `Dir.children('/')`.

Outcomes: **PASS** = L2; **EXEC** = L0 without L2 (the gadget works, but the harness can't
drive `ls /` through that shell — a fixed `-c` command from a libc global, an uncontrolled
`argv[1]` that `sh` treats as a script name, or a `posix_spawn` parent/child tty race);
**FAIL** = neither (a candidate one_gadget bug, especially under `--strict`); **SKIP** = the
satisfier produced no plan. EXEC exists because "reaches a shell" and "we can drive that shell"
are different questions — conflating them would mislabel working gadgets as failures.

**Promotion (EXEC\*)**: an EXEC gadget is retried with the uncontrolled registers nulled
(`null_default`). Many EXEC results are only inconclusive because the code writes an
uncontrolled register as `argv[1]`, and the benign fill makes it a garbage-but-readable string
that `sh` treats as a script name and exits. Nulling that register terminates argv, so the
shell is interactive and runs `ls /`. If the null-fill retry PASSes, the gadget is reported
EXEC\* — genuinely usable given that (attacker-controlled) input. If it still can't drive (a
fixed `-c` command from a libc constant), it stays EXEC.

## Independence principle (important)

The tool under verification must not be its own judge. So:

- **The verdict is empirical only**: PASS iff a real shell ran `ls /` and returned the real
  root. No part of the decision consults one_gadget's belief about its constraints.
- The operand parser (`lib/aletheia/operand.rb`) is written from scratch, not reused from
  the emulator's `Lambda.parse`, so an emulator parsing bug can't mask itself in the checker.
- Bugs are expected to live in the constraint list — most often a *missing* constraint.

## The satisfier

`Satisfier#satisfy` is the inverse of one_gadget's `gadget.rb#calculate_score`: same
category dispatch, but it emits assignments instead of scores. For each constraint it
splits on ` || `, scores each disjunct's cost (nil = unsatisfiable / unsupported), and
takes the cheapest satisfiable branch. Memory model: one zeroed scratch region, `sp` set
to `scratch + sp_offset`, so sp-relative NULL/writable requirements are free.

Categories handled today: `writable: <reg+imm>` (point the register into a scratch
write-area), `<op> == NULL` / `<op> <= 0` (bare reg -> 0; sp+imm -> unsatisfiable, so the
other branch wins; sp-relative deref -> free via zero-fill). `is a valid argv/envp` is
scored expensive and not yet built (the native-2.43 and older-execve sets always have a
cheaper NULL branch); building it is the next satisfier task.

## Benign vs poison (the completeness test)

`driver.py` fills registers the plan doesn't set. **Benign** points them at readable
scratch (reproduces a gadget under favorable state). **Poison** (`--strict`) sets them to
an unmapped address so any *unlisted* dereference faults — this is what turns "the gadget
works if you're lucky" into "the constraint list is complete". A poison fault with a fully
satisfied plan is a candidate missing-constraint bug.

## Constraint-discovery loop

When a satisfied plan FAILs (esp. under poison), find the real precondition:

1. `discover.py` runs the plan under poison and, on the fault, prints the faulting
   instruction relative to base and all GPRs. That is the concrete lead.
2. Set the implicated register to a plausible value, re-run; iterate until `ls /` works.
   The delta between the failing and passing plan *is* the missing constraint.
3. Root-cause in one_gadget (emulator/fetcher) and record in `FINDINGS.md`.

`docs/FINDINGS.md`'s Finding 1 is a worked example (missing `sigprocmask` `set`-pointer
constraint, traced to `emulators/arm_family.rb`'s `inst_bl` checker).

## Result discriminator

A FAIL is a one_gadget bug only if the plan was **complete, conflict-free, and fully
satisfied**. A SKIP / conflict / unsatisfiable-branch / environment error (e.g. a libc
that won't `dlopen`) is a harness limitation, not a verdict on the gadget.

## Known limitations

- Older libcs may not `dlopen` standalone on a newer host (e.g. `aarch64-libc-2.27.so`
  aborts with SIGILL on glibc 2.43). Fallback loaders (explicit old `ld.so`, or manual
  map+relocate) are future work.
- The argv/envp builder is not implemented yet (not needed for the current fixtures).
- `x29`/frame-chain assumptions: poison leaves x29 poisoned; if a gadget needs a valid
  frame this shows up as a fault — treat with the discovery loop before calling it a bug.
