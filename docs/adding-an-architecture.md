# Adding a new architecture

Supporting an architecture means two classes plus a little wiring. The cleanest
existing example to copy is **aarch64** (`lib/one_gadget/fetchers/aarch64.rb` and
`lib/one_gadget/emulators/aarch64.rb`).

```ruby
OneGadget::Fetchers::<Arch>  < OneGadget::Fetchers::Base   # find candidates, describe constraints
OneGadget::Emulators::<Arch> < X86 | ArmFamily | Processor # execute a candidate: inherit a family base, or Processor for a new family
```

The engine (candidate discovery via a control-flow walk, constraint solving,
gadget trimming) lives in the base classes. Each architecture only fills in the
parts that differ.

## At a glance

**Who owns what.** Two parallel hierarchies (fetcher, emulator); the engine base
classes carry the shared logic, and each arch subclass fills in the boxes marked
_you implement_. Arches in the same family share a base class that sits between
`Processor` and the concrete arch: `amd64`/`i386` inherit `X86`, `arm`/`aarch64`
inherit `ArmFamily` (each holding that family's instruction set, mnemonic tables,
and condition codes). The fetcher reaches its emulator through `emulator()`.

```mermaid
flowchart LR
  classDef engine fill:#dbeafe,stroke:#2563eb,color:#1e3a8a,font-family:monospace
  classDef arch fill:#dcfce7,stroke:#16a34a,color:#14532d,font-family:monospace
  classDef mixin fill:#ede9fe,stroke:#7c3aed,color:#4c1d95,font-family:monospace
  classDef family fill:#fef3c7,stroke:#d97706,color:#78350f,font-family:monospace

  subgraph FE["Fetcher side: find candidate sequences"]
    direction TB
    FB["Fetchers::Base<br/>(engine)"]:::engine
    FA["Fetchers::&lt;Arch&gt;<br/>(you implement)"]:::arch
    FB -->|inherits| FA
  end
  subgraph EM["Emulator side: execute one candidate"]
    direction TB
    EP["Emulators::Processor<br/>(engine)"]:::engine
    CO["modules mixed into Processor:<br/>Conditional, Constraints,<br/>TrackedMemory, DataProcessing"]:::mixin
    FAM["X86 / ArmFamily<br/>(family base class)"]:::family
    EA["Emulators::&lt;Arch&gt;<br/>(you implement)"]:::arch
    EP -->|inherits| FAM
    FAM -->|inherits| EA
    CO -.->|mixed into| EP
  end
  FA ==>|"emulator()"| EA
```

Legend: 🟦 engine (shared base) · 🟨 family base class · 🟩 what you implement · 🟪 shared mixin.

What each box is for:

- **`Fetchers::Base`** — the engine: walks the CFG for candidate sequences, then solves and trims gadgets.
- **`Fetchers::<Arch>`** — the arch's disassembly, its string/branch recognition, and how to build its emulator.
- **`Emulators::Processor`** — the engine: the emulation lifecycle (parse, dispatch) and the calls a candidate may cross.
- **`module Conditional`** — shared compare/branch machinery; a crossed branch becomes a gadget constraint.
- **`module Constraints`** — what a gadget requires of its caller, and which of those requirements another already implies.
- **`module TrackedMemory`** — the memory a candidate reads and writes, filed under the base each address is an offset from.
- **`module DataProcessing`** — what an instruction leaves in a register (`arith`, `data_op`, and the helpers they are built from).
- **`X86` / `ArmFamily`** — a family base class between `Processor` and the concrete arch, holding that family's shared instruction set, mnemonic tables, and condition codes.
- **`Emulators::<Arch>`** — emulate each instruction, plus the calling convention and register model.

**Why each piece exists.** The runtime flow shows where your methods are called
and what they feed:

```mermaid
flowchart TD
  classDef entry fill:#fef9c3,stroke:#ca8a04,color:#713f12,font-family:monospace
  classDef engine fill:#dbeafe,stroke:#2563eb,color:#1e3a8a,font-family:monospace
  classDef arch fill:#dcfce7,stroke:#16a34a,color:#14532d,font-family:monospace
  classDef mixin fill:#ede9fe,stroke:#7c3aed,color:#4c1d95,font-family:monospace
  classDef out fill:#ffe4e6,stroke:#e11d48,color:#881337,font-family:monospace

  A["OneGadget.gadgets(file)"]:::entry --> B["Fetchers::&lt;Arch&gt;#find"]:::arch
  B --> C["Base#candidates<br/>(backward CFG walk)"]:::engine
  C --> D{"for each start instruction"}
  D --> E["Base#emulate<br/>(process! per instruction)"]:::engine
  E --> F["module Conditional<br/>(per instruction)"]:::mixin
  E --> G["arch inst_* handlers"]:::arch
  F --> H["branch → constraint"]:::mixin
  D --> I["Base#resolve<br/>(argv / envp checks)"]:::engine
  H --> J["Gadget<br/>(offset + constraints)"]:::out
  I --> J
```

Reading the flow:

- **`candidates`** walks the CFG backward from each `exec*`/`posix_spawn*` call to build candidate sequences.
- **`find`** emulates every start instruction of each candidate, one instruction at a time.
- **`Conditional`** runs first on each instruction (`resolve_pending_branch` → `handle_compare` → `handle_branch` → `branch_on_*`), turning a crossed branch into a constraint.
- the arch's **`inst_*`** handlers then update the register/stack state.
- **`resolve`** reads the call's arguments (`argument`, `str_bin_sh?`, `global_var?`) and builds the argv/envp constraints.
- finally, a contradiction drops the gadget and a tautology is stripped.

## The fetcher — `Fetchers::<Arch> < Fetchers::Base`

| Method | What it returns |
| --- | --- |
| `emulator` | a fresh `Emulators::<Arch>` instance |
| `call_str` | the call mnemonic that reaches a function — `'bl'` (arm/aarch64), `'call'` (x86) |
| `str_bin_sh?(operand)` | does this operand reference the `"/bin/sh"` string? |
| `str_sh?(operand)` | does it reference the standalone `"sh"` string? |
| `global_var?(operand)` | does it reference a libc global (i.e. is it `$base`-relative)? |
| `branch_kind(line)` | classify an instruction: `:conditional`, `:unconditional`, `:terminator`, or `nil` (not a branch) |
| `branch_lead_chars` | the leading character(s) of this arch's branch mnemonics, e.g. `'bct'` or `'j'` (a cheap filter) |

`branch_kind` is the one method that drives the control-flow walk:

* `:conditional` — may or may not be taken; both edges are explored and the
  decision becomes a gadget constraint (e.g. `x2 == 0x1`).
* `:unconditional` — always taken, to a determined target.
* `:terminator` — ends the path (a return or an indirect/computed jump).
* `nil` — not a branch; execution falls through to the next instruction.

Optional hooks (sensible defaults in `Base`):

| Method | Default | Purpose |
| --- | --- | --- |
| `objdump_options` | `[]` | extra objdump flags, e.g. x86 returns `%w[-M intel]` |
| `scan_calls(base, data, targets)` | `nil` | find the direct calls into `targets` in `.text` (given as `data`, loaded at `base`), so only windows around them are disassembled instead of the whole file. One masked compare per instruction is usually enough; see `Fetchers::AArch64` for the simplest, `Fetchers::X86` for a variable-length one. Over-approximating is fine; a missed call costs the gadgets around it. `nil` = disassemble the whole file. |
| `symbol_address(value)` | `value` | what a symbol's value names, where it carries more than the address (`Fetchers::Arm` masks off the Thumb bit). |

## The emulator — `Emulators::<Arch> < Emulators::Processor`

| Method | What it does |
| --- | --- |
| `initialize` | `super(OneGadget::ABI.<arch>, sp_name)`, set `@pc`, define constant registers, and call `setup_frame_pointer(bp)` if the arch tracks a frame pointer |
| `instructions` | the `Instruction`s this arch models (anything else aborts the path) |
| `process!(cmd)` | emulate one instruction (see the pattern below) |
| `argument(idx)` | the value of the idx-th call argument (the calling convention) |
| `self.bits` | `32` or `64` |
| `operands(cmd)` | split an instruction into its operand strings |
| `branch_mnem?(mnem)` | is `mnem` a branch this emulator handles? |
| `handle_branch(mnem, cmd)` | turn a branch into a pending decision (via the `branch_on_*` helpers below) |
| `inst_<name>(...)` | one handler per supported instruction |

**Inherited from `Processor` — don't reimplement.** The frame-pointer/stack model
(`get_corresponding_stack`, `setup_frame_pointer`, `eval_dict`, `reg_based_stack`)
and the store tracker (`track_write`, which writes each word into the stack the
address resolves to and requires anything but a pure `sp` store writable) come from
`TrackedMemory`; the writable-constraint logic (`add_writable`/`needs_writable?`,
which skip `sp`, `pc`, and `libc_base` for free) and the rest of the requirement
collection from `Constraints`; the value-computing helpers an `inst_*` handler is
built from (`arith` for add/sub — including the refusal to let `sp` go symbolic —
`data_op` for a bitwise or shift operator, `complement`, `shorthand`, `value_of`,
`width_mask`) from `DataProcessing`. The libc-base marker (`libc_base`,
`mapped_pointer?`) and the table of non-terminal libc calls the emulator accepts
without executing (`SafeCalls::COMMON`, applied by `dispatch_safe_call` — the
`posix_spawn` setup helpers, `sigprocmask`, `__sigaction`, …) are all
architecture-independent and live in `Processor`/`SafeCalls`. A new arch inherits
them unchanged. **Keep it that way:** anything whose behaviour doesn't genuinely
depend on the ISA belongs in the shared base, never copied into an arch class — a
per-arch copy of the safe-call table once let one arch gain a constraint the
others silently lacked.

`process!` follows a fixed shape — resolve any pending branch, handle a
compare/branch, otherwise parse and dispatch:

```ruby
def process!(cmd)
  resolve_pending_branch(cmd)                                       # from Conditional
  mnem = mnemonic(cmd)                                              # from Conditional
  return handle_compare(COMPARES[mnem], cmd) if COMPARES.key?(mnem) # from Conditional
  return handle_branch(mnem, cmd) != :fail if branch_mnem?(mnem)

  inst, args = parse(cmd)
  __send__(:"inst_#{inst.inst}", *args) != :fail
end
```

The **`Emulators::Conditional`** module (already included in `Processor`) provides
the branch machinery so you don't reimplement it: `record_compare`,
`handle_compare`, `branch_on_compare`, `branch_on_zero`, `branch_on_bit`,
`resolve_pending_branch`, `operand_str`, `mnemonic`. You supply two small adapter
tables that map your arch's mnemonics onto the shared vocabulary (directly, or via
a shared base — arm/aarch64 share theirs through `ArmFamily`):

* **`COMPARES`** — compare mnemonic → ALU op (a `Conditional::COMPARE_OPS` key:
  `:sub` for `cmp`, `:add` for `cmn`, `:and` for `tst`/`test`); `handle_compare`
  reads it.
* **`COND`** (x86 calls it `JCC`) — branch mnemonic → predicate (a
  `Conditional::RELATION` key, e.g. `:ne`, `:uge`). Your `handle_branch` parses the
  instruction and calls the right `branch_on_*`, passing this predicate to `branch_on_compare`.

## Wiring

* `OneGadget::Helper.architecture` — map the ELF machine string to your arch symbol.
* `OneGadget::Fetchers.from_file` — add the arch symbol → `Fetchers::<Arch>` entry.
* `OneGadget::Helper.arch_specific_objdump` — the cross objdump binary name.

## Tests

Add a `spec/one_gadget_<arch>_spec.rb` that runs `OneGadget.gadgets` against a
real libc fixture and asserts the exact gadget offsets, plus emulator unit tests
in `spec/emulators/<arch>_spec.rb`.
