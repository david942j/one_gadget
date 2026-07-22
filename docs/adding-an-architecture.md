# Adding a new architecture

Supporting an architecture means two classes plus a little wiring. The cleanest
existing example to copy is **aarch64** (`lib/one_gadget/fetchers/aarch64.rb` and
`lib/one_gadget/emulators/aarch64.rb`).

```ruby
OneGadget::Fetcher::<Arch>  < OneGadget::Fetcher::Base       # find candidates, describe constraints
OneGadget::Emulators::<Arch> < OneGadget::Emulators::Processor # symbolically execute a candidate
```

The engine (candidate discovery via a control-flow walk, constraint solving,
gadget trimming) lives in the base classes. Each architecture only fills in the
parts that differ.

## The fetcher — `Fetcher::<Arch> < Fetcher::Base`

| Method | What it returns |
| --- | --- |
| `emulator` | a fresh `Emulators::<Arch>` instance |
| `call_str` | the call mnemonic that reaches a function — `'bl'` (arm/aarch64), `'call'` (x86) |
| `str_bin_sh?(operand)` | does this operand reference the `"/bin/sh"` string? |
| `str_sh?(operand)` | does it reference the standalone `"sh"` string? |
| `global_var?(operand)` | does it reference a libc global (i.e. is it `$base`-relative)? |
| `branch_kind(line)` | classify a line: `:conditional`, `:unconditional`, `:terminator`, or `nil` (not a branch) |
| `branch_lead_chars` | the leading character(s) of this arch's branch mnemonics, e.g. `'bct'` or `'j'` (a cheap filter) |

`branch_kind` is the one method that drives the control-flow walk:

* `:conditional` — may or may not be taken; both edges are explored and the
  decision becomes a gadget constraint (e.g. `x2 == 0x1`).
* `:unconditional` — always taken, to a determined target.
* `:terminator` — ends the path (a return or an indirect/computed jump).
* `nil` — not a branch; execution falls through to the next line.

Optional hooks (sensible defaults in `Base`):

| Method | Default | Purpose |
| --- | --- | --- |
| `objdump_options` | `[]` | extra objdump flags, e.g. x86 returns `%w[-M intel]` |
| `terminal_call_sites` | `nil` | if the calls can be located cheaply *without* disassembling everything, return their addresses for windowed disassembly (a big win when a full objdump is slow, as on Thumb-2 arm). `nil` = disassemble the whole file. See `Fetcher::Arm`. |

## The emulator — `Emulators::<Arch> < Emulators::Processor`

| Method | What it does |
| --- | --- |
| `initialize` | `super(OneGadget::ABI.<arch>, sp_name)`, set `@pc`, define constant registers |
| `instructions` | the `Instruction`s this arch models (anything else aborts the path) |
| `process!(cmd)` | emulate one line (see the pattern below) |
| `argument(idx)` | the value of the idx-th call argument (the calling convention) |
| `get_corresponding_stack(obj)` | the sp/bp-based stack hash `obj` addresses, or `nil` |
| `self.bits` | `32` or `64` |
| `operands(cmd)` | split a line into its operand strings |
| `branch_mnem?(mnem)` | is `mnem` a branch this emulator handles? |
| `handle_branch(mnem, cmd)` | turn a branch into a queued decision (via the helpers below) |
| `inst_<name>(...)` | one handler per supported instruction |

`process!` follows a fixed shape — resolve any pending branch, handle a
compare/branch, otherwise parse and dispatch:

```ruby
def process!(cmd)
  resolve_pending_branch(cmd)                 # from Conditional
  mnem = mnemonic(cmd)                         # from Conditional
  return handle_compare(mnem, cmd) if %w[cmp ...].include?(mnem)  # from Conditional
  return handle_branch(mnem, cmd) != :fail if branch_mnem?(mnem)

  inst, args = parse(cmd)
  __send__(:"inst_#{inst.inst}", *args) != :fail
end
```

The **`Emulators::Conditional`** module (already included in `Processor`) provides
the branch machinery so you don't reimplement it: `record_compare`,
`queue_cond_branch`, `queue_cbz`, `queue_tbz`, `resolve_pending_branch`,
`handle_compare`, `operand_str`, `mnemonic`. Your `handle_branch` just parses the
line and calls the right `queue_*`.

## Wiring

* `OneGadget::Helper.architecture` — map the ELF machine string to your arch symbol.
* `OneGadget::Fetcher.from_file` — add the arch symbol → `Fetcher::<Arch>` entry.
* `OneGadget::Helper.arch_specific_objdump` — the cross objdump binary name.

## Tests

Add a `spec/one_gadget_<arch>_spec.rb` that runs `OneGadget.gadgets` against a
real libc fixture and asserts the exact gadget offsets, plus emulator unit tests
in `spec/emulators/<arch>_spec.rb`.
