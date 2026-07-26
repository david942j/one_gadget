# gdb-Python driver: inject a satisfier plan and let the gadget run.
#
# Reads a JSON plan (path in $ALETHEIA_PLAN) describing the register and scratch
# setup, jumps pc to base+offset, and continues so the spawned shell runs on the
# inferior tty. The Ruby oracle drives that tty and decides PASS/FAIL.
#
# Run under: gdb -nx -q -batch -x driver.py --args ./park_stub <target-libc.so>
import gdb
import json
import os

plan = json.load(open(os.environ["ALETHEIA_PLAN"]))
offset = int(plan["offset"], 0)

gdb.execute("set pagination off")
gdb.execute("set confirm off")
gdb.execute("break pause")
gdb.execute("run")

pid = gdb.selected_inferior().pid


def base_of(basename):
    # Lowest mapping whose file basename matches -> the load bias.
    lo = None
    for line in open("/proc/%d/maps" % pid):
        parts = line.split()
        if len(parts) >= 6 and parts[5].split("/")[-1] == basename:
            start = int(parts[0].split("-")[0], 16)
            lo = start if lo is None else min(lo, start)
    return lo


# The target file's own mapping if present; otherwise the host libc (which is
# what dlopen returns when the target *is* the host libc, deduped to libc.so.6).
target_base = os.path.basename(os.environ.get("ALETHEIA_TARGET", ""))
base = base_of(target_base) or base_of("libc.so.6")
if base is None:
    gdb.write("ALETHEIA_ERROR: libc base not found\n")
    raise SystemExit(1)

gadget = base + offset
gdb.write("ALETHEIA base=%#x gadget=%#x\n" % (base, gadget))

scratch_size = plan.get("scratch_size", 0x10000)
scratch = int(gdb.parse_and_eval("(void*)mmap(0, %d, 3, 0x22, -1, 0)" % scratch_size)) & 0xFFFFFFFFFFFFFFFF
if scratch == 0xFFFFFFFFFFFFFFFF:
    gdb.write("ALETHEIA_ERROR: inferior mmap failed\n")
    raise SystemExit(1)

# Seed the L2 command at a fixed scratch offset. A gadget whose argv is forced to
# `sh -c <cmd>` (no empty-argv escape) points its command slot here, so the shell
# runs `ls /` itself instead of reading it from stdin. Keep in sync with the
# satisfier's COMMAND_POOL.
gdb.selected_inferior().write_memory(scratch + 0x200, b"ls /\x00")

# Default fill for registers the plan does not set:
#  - benign: point at readable zeroed scratch, so the only uncontrolled inputs
#    are those the constraints govern (biases toward reproducing a stated gadget).
#  - poison: an unmapped address, so ANY unlisted dereference faults. This tests
#    whether the constraint list is *complete*; a fault under poison that the
#    listed constraints don't explain is a candidate missing-constraint bug.
POISON = 0xDEAD0000
if plan.get("poison_default"):
    for i in range(31):
        gdb.execute("set $x%d = %#x" % (i, POISON))
elif plan.get("benign_default"):
    for i in range(31):
        gdb.execute("set $x%d = %#x" % (i, scratch + 0x100))

for reg, val in plan.get("regs", {}).items():
    # Plan values may be ints or {"scratch_off": N} to resolve against scratch.
    if isinstance(val, dict) and "scratch_off" in val:
        val = scratch + val["scratch_off"]
    gdb.execute("set $%s = %#x" % (reg, int(val) & 0xFFFFFFFFFFFFFFFF))

sp = scratch + plan.get("sp_offset", 0x2000)
gdb.execute("set $sp = %#x" % sp)
gdb.execute("set $pc = %#x" % gadget)

gdb.execute("set follow-fork-mode child")
gdb.write("ALETHEIA_INJECTED sp=%#x scratch=%#x\n" % (sp, scratch))


def readable(addr):
    if addr == 0:
        return True  # NULL argv/envp is accepted by execve (empty)
    try:
        gdb.selected_inferior().read_memory(addr, 8)
        return True
    except gdb.MemoryError:
        return False


SHELLS = ("dash", "bash", "sh", "busybox", "zsh")


def execd_shell(pid):
    try:
        return os.path.basename(os.readlink("/proc/%d/exe" % pid)) in SHELLS
    except OSError:
        return False


# L0: the deterministic "the gadget reaches a shell" signal, independent of
# whether L2 can then drive that shell over the tty. A straight-line execve
# stops at the syscall entry, where we verify the "/bin/sh" path and readable
# argv/envp. posix_spawn execs in a vforked child that runs straight through to
# the new program, so there we confirm the exec'd image is a shell instead.
gdb.execute("catch syscall execve execveat")
gdb.execute("continue")
l0 = False
try:
    if int(gdb.parse_and_eval("$x8")) in (221, 281):
        path = gdb.execute("x/s $x0", to_string=True)
        argv = int(gdb.parse_and_eval("$x1")) & 0xFFFFFFFFFFFFFFFF
        envp = int(gdb.parse_and_eval("$x2")) & 0xFFFFFFFFFFFFFFFF
        l0 = ('"/bin/sh"' in path) and readable(argv) and readable(envp)
except gdb.error:
    pass
if not l0:
    l0 = execd_shell(gdb.selected_inferior().pid)
gdb.write("ALETHEIA_L0=%s\n" % ("pass" if l0 else "fail"))

# Let the shell run for the L2 (`ls /`) check on the tty.
gdb.execute("delete")
gdb.execute("continue")
