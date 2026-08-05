# EXEC backlog

`EXEC` means the gadget **reached `execve`/`posix_spawn`** but the level-2 oracle
never got a shell to run `ls /`. Unlike `SKIP` (no plan could be built) an EXEC
run proves the gadget works up to the exec; what's missing is a shell we can
drive. These are worked through one category at a time, the way the SKIP
categories were.

Counts below are from the strict level-2 sweep after the memory-operand
relation fix (88 EXEC across 6 fixtures, all amd64, all `execve`).

| fixture | EXEC | example |
| --- | --- | --- |
| libc-2.19-cf699a15caae64 | 25 | 0xe56a1 |
| libc-2.23-60131540dadc67 | 18 | 0xef609 |
| libc-2.26-ddcc13122ddbfe | 18 | 0xfcbe1 |
| libc-2.24-8cba3297f53869 | 9 | 0xd665b |
| libc-2.26-2104f3d4ad5cf6 | 9 | 0xe2833 |
| libc-2.27-b417c0ba7cc5cf | 9 | 0x10a23e |

## Category 1 -- empty argv from the cheap NULL branch

The dominant shape. The gadget is `execve("/bin/sh", rsp+0x50, environ)` with

```
[rsp+0x50] == NULL || {[rsp+0x50], [rsp+0x58], [rsp+0x60], [rsp+0x68], ...} is a valid argv
```

Both disjuncts are satisfiable, and the satisfier takes the cheaper one -- an
`sp`-relative slot reading NULL costs almost nothing, while building the array
costs more. That yields `execve("/bin/sh", {NULL}, environ)`: a shell started
with **no `argv[0]`**, which execs fine but gives the pty nothing to drive.

The gadget itself is not at fault -- a real attacker would populate argv. This
is the satisfier picking the branch that is cheapest to *satisfy* rather than
the one that produces an *observable* shell.

Fix direction: when the effect is an exec whose argv operand is the one being
constrained, prefer the array branch and build `{"sh", "-c", "ls /"}` (the
machinery already exists in `apply_argv_list`, including the COMMAND_POOL
seeding for `-c`). Only fall back to the NULL branch if the array can't be
built. Worth checking whether the same reasoning applies to envp.

Expect this to convert most of the 88 to PASS, and to reclassify any residue
into a smaller, more interesting category.

## Category 2 -- close-stdout shells (task #32)

A separate, genuinely-unobservable family: gadgets reached through `popen`
internals where the child's stdout is closed before the exec, so a shell does
run but its output can never reach the oracle. These need one_gadget to flag
them (task #32) rather than the harness to work harder; a shell with no stdout
is still useful to an attacker (e.g. a reverse shell), so they should be kept
and marked, not dropped.

## Method

Same loop as the SKIP work: categorise by the *first* thing that blocks
observation, fix the largest category, re-sweep, re-categorise. A category may
split once its top blocker is removed, and some EXEC gadgets may turn out to be
FAIL (reaching exec but genuinely unable to produce a shell) -- which is a real
finding about the constraint list, not a harness gap.
