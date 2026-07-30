# Constraint-discovery helper: run one gadget under poison and, on a fault,
# report the faulting instruction (relative to libc base) and the registers it
# touched -- the concrete lead for "which precondition did one_gadget omit?".
#
# Run under: gdb -nx -q -batch -x discover.py --args ./park_stub <target-libc.so>
# Params via env: ALETHEIA_PLAN (json), ALETHEIA_TARGET.
import gdb
import json
import os
import struct

plan = json.load(open(os.environ["ALETHEIA_PLAN"]))
offset = int(plan["offset"], 0)

gdb.execute("set pagination off")
gdb.execute("set confirm off")
gdb.execute("break pause")
gdb.execute("run")

pid = gdb.selected_inferior().pid


def base_of(basename):
    lo = None
    for line in open("/proc/%d/maps" % pid):
        parts = line.split()
        if len(parts) >= 6 and parts[5].split("/")[-1] == basename:
            start = int(parts[0].split("-")[0], 16)
            lo = start if lo is None else min(lo, start)
    return lo


target_base = os.path.basename(os.environ.get("ALETHEIA_TARGET", ""))
base = base_of(target_base) or base_of("libc.so.6")
gadget = base + offset

scratch = int(gdb.parse_and_eval("(void*)mmap(0, 0x20000, 3, 0x22, -1, 0)")) & 0xFFFFFFFFFFFFFFFF  # keep in sync with Satisfier::SCRATCH_SIZE
gdb.selected_inferior().write_memory(scratch + 0x200, b"ls /\x00")

# Fill uncontrolled registers the same way the driver does for this plan.
if plan.get("poison_default"):
    fill = 0xDEAD0000
elif plan.get("benign_default"):
    fill = scratch + 0x100
else:
    fill = None
if fill is not None:
    for i in range(31):
        gdb.execute("set $x%d = %#x" % (i, fill))
for reg, val in plan.get("regs", {}).items():
    if isinstance(val, dict) and "scratch_off" in val:
        val = scratch + val["scratch_off"]
    gdb.execute("set $%s = %#x" % (reg, int(val) & 0xFFFFFFFFFFFFFFFF))
# Scratch-relative memory writes (cf. driver.py) -- aarch64-only here, always 8 bytes.
for off, val in plan.get("mem", {}).items():
    off = int(off)
    if isinstance(val, dict) and "scratch_off" in val:
        val = scratch + val["scratch_off"]
    gdb.selected_inferior().write_memory(scratch + off, struct.pack("<Q", int(val) & 0xFFFFFFFFFFFFFFFF))
gdb.execute("set $sp = %#x" % (scratch + plan.get("sp_offset", 0x10000)))  # keep in sync with Satisfier::SP_OFFSET
gdb.execute("set $pc = %#x" % gadget)

gdb.write("BASE=%#x GADGET=%#x SCRATCH=%#x\n" % (base, gadget, scratch))
gdb.execute("set follow-fork-mode child")
gdb.execute("catch syscall execve execveat")
gdb.execute("continue")
# On reaching execve, report its arguments before the image is replaced.
try:
    nr = int(gdb.parse_and_eval("$x8"))
    if nr in (221, 281):
        path = gdb.execute("x/s $x0", to_string=True).strip()
        gdb.write("EXECVE path=%s argv=%#x envp=%#x\n"
                  % (path, int(gdb.parse_and_eval("$x1")) & 0xFFFFFFFFFFFFFFFF,
                     int(gdb.parse_and_eval("$x2")) & 0xFFFFFFFFFFFFFFFF))
except gdb.error:
    pass

# If we get here via a signal, report the fault site.
try:
    pc = int(gdb.parse_and_eval("$pc")) & 0xFFFFFFFFFFFFFFFF
    gdb.write("FAULT_PC=%#x (base+%#x)\n" % (pc, pc - base))
    gdb.write("FAULT_INSN=%s\n" % gdb.execute("x/i $pc", to_string=True).strip())
    gdb.write("--- context ---\n")
    gdb.write(gdb.execute("x/3i $pc", to_string=True))
    for i in range(31):
        gdb.write("x%d=%s " % (i, gdb.execute("p/x $x%d" % i, to_string=True).split('=')[1].strip()))
    gdb.write("\n")
except gdb.error as e:
    gdb.write("no-fault-context (%s)\n" % e)
