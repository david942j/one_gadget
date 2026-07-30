# gdb-Python driver: inject a satisfier plan and let the gadget run.
#
# Transport-agnostic: connects natively (`run`) or to a qemu-user gdbstub
# (`target remote`), reads the libc base + scratch address the self-describing
# park_stub wrote to $ALETHEIA_STUB_OUT (no inferior mmap, no /proc from gdb),
# then injects the plan and runs. Register names / syscall numbers come from the
# plan's "arch" block, so the same driver serves every architecture.
import gdb
import json
import os
import re
import struct

MASK = 0xFFFFFFFFFFFFFFFF
plan = json.load(open(os.environ["ALETHEIA_PLAN"]))
arch = plan["arch"]
offset = int(plan["offset"], 0)

gdb.execute("set pagination off")
gdb.execute("set confirm off")
if arch.get("gdb_arch"):
    gdb.execute("set architecture %s" % arch["gdb_arch"])

# Park at the stub's marker, then bring the inferior to it (native runs it;
# a remote target is already running and just needs `continue`).
gdb.execute("break aletheia_park")
connect = os.environ.get("ALETHEIA_CONNECT", "run")
if connect == "run":
    gdb.execute("run")
else:
    gdb.execute("target remote %s" % connect)
    gdb.execute("continue")

info = open(os.environ["ALETHEIA_STUB_OUT"]).read()
base = int(re.search(r"ALETHEIA_BASE=(0x[0-9a-fA-F]+)", info).group(1), 16)
scratch = int(re.search(r"ALETHEIA_SCRATCH=(0x[0-9a-fA-F]+)", info).group(1), 16)
gadget = base + offset
gdb.write("ALETHEIA base=%#x gadget=%#x scratch=%#x\n" % (base, gadget, scratch))

# Seed the L2 command; a `sh -c <cmd>` gadget points its command slot here so the
# shell runs `ls /` itself. Keep in sync with the satisfier's COMMAND_POOL.
gdb.selected_inferior().write_memory(scratch + 0x200, b"ls /\x00")

# Default fill for registers the plan doesn't set: benign (readable scratch),
# poison (unmapped -> unlisted derefs fault), or null (0 -> argv terminates).
POISON = 0xDEAD0000
if plan.get("poison_default"):
    fill = POISON
elif plan.get("null_default"):
    fill = 0
elif plan.get("benign_default"):
    fill = scratch + 0x100
else:
    fill = None
if fill is not None:
    for r in arch["gprs"]:
        gdb.execute("set $%s = %#x" % (r, fill))

def set_reg(reg, val):
    # gdb rejects `set $xmm0 = <int>` (an XMM register is a vector union, not a
    # scalar). The satisfier only ever pins an XMM lane to a u64 (a `(u64)xmm*`
    # constraint), so write the 64-bit lanes directly.
    if reg.startswith("xmm"):
        gdb.execute("set $%s.v2_int64[0] = %#x" % (reg, val & MASK))
        gdb.execute("set $%s.v2_int64[1] = 0" % reg)
    else:
        gdb.execute("set $%s = %#x" % (reg, val & MASK))


for reg, val in plan.get("regs", {}).items():
    if isinstance(val, dict):
        if "scratch_off" in val:
            val = scratch + val["scratch_off"]        # a scratch pointer
        elif "base_off" in val:
            val = base + val["base_off"]              # a libc load-base offset (i386 GOT)
    set_reg(reg, int(val))

# Scratch-relative memory writes (a pointer value, keyed by the offset to write
# it at) -- built by the satisfier for a chained dereference like `[[sp]]`,
# where the first level needs a real pointer rather than the zero-fill a single
# dereference relies on. See Satisfier#apply_deep_null.
word_size = arch.get("word_size", 8)
word_fmt = {4: "<I", 8: "<Q"}[word_size]
word_mask = (1 << (word_size * 8)) - 1
for off, val in plan.get("mem", {}).items():
    off = int(off)
    if isinstance(val, dict) and "scratch_off" in val:
        val = scratch + val["scratch_off"]
    gdb.selected_inferior().write_memory(scratch + off, struct.pack(word_fmt, int(val) & word_mask))

sp = scratch + plan.get("sp_offset", 0x2000)
gdb.execute("set $%s = %#x" % (arch["sp"], sp))
gdb.execute("set $%s = %#x" % (arch["pc"], gadget))
if arch.get("thumb"):
    gdb.execute("set $cpsr = ($cpsr | 0x20)")  # arm: enter Thumb state (CPSR T bit)

# posix_spawn forks a child that execs the shell. Natively, gdb follows the child
# and drives it directly. Over a qemu-user gdbstub, a single stub can't debug both
# sides of a fork, so let the child run free (it inherits the guest tty) and stay
# with the parent -- L2 on the pty is the arbiter either way.
try:
    if connect == "run":
        gdb.execute("set follow-fork-mode child")
        gdb.execute("set detach-on-fork off")
    else:
        gdb.execute("set follow-fork-mode parent")
        gdb.execute("set detach-on-fork on")
except gdb.error:
    pass


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


# L0: the deterministic "reaches a shell" signal. A straight-line execve stops at
# the syscall entry, where we verify the "/bin/sh" path and readable argv/envp;
# posix_spawn runs through to the new image, caught by `catch exec` -- but only
# natively, where the vforked child is followed (`follow-fork-mode child` above).
# Over a qemu-user gdbstub the child is never followed, so `catch exec` can only
# ever fire in the (non-execing) parent -- useless there, and qemu-aarch64's
# gdbstub SIGSEGVs some straight-line execl() paths when it's armed regardless
# (reproduced: works cleanly without it, corrupts execl with it).
gdb.execute("catch syscall execve execveat")
if connect == "run":
    try:
        gdb.execute("catch exec")
    except gdb.error:
        pass
gdb.execute("continue")
l0 = False
try:
    if int(gdb.parse_and_eval("$" + arch["sysno_reg"])) in arch["execve_syscalls"]:
        path = gdb.execute("x/s $" + arch["path_reg"], to_string=True)
        argv = int(gdb.parse_and_eval("$" + arch["argv_reg"])) & MASK
        envp = int(gdb.parse_and_eval("$" + arch["envp_reg"])) & MASK
        l0 = ('"/bin/sh"' in path) and readable(argv) and readable(envp)
except gdb.error:
    pass
if not l0 and connect == "run":
    l0 = execd_shell(gdb.selected_inferior().pid)
gdb.write("ALETHEIA_L0=%s\n" % ("pass" if l0 else "fail"))

# Let the shell run for the L2 (`ls /`) check on the tty.
gdb.execute("delete")
gdb.execute("continue")
