# Changelog

Notable changes to one_gadget, newest first. The format follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and the project follows
[Semantic Versioning](https://semver.org/).

A change worth a user's attention lands with its entry under *Unreleased*;
releases are cut by giving that section a version and a date.

## Unreleased

### Added

- RISC-V (RV64) support, alongside i386, amd64, aarch64 and arm (#420, #421,
  #422, #423, #425). Every gadget the riscv64 fixture reports has been run under
  a debugger and seen to spawn a real shell, the same bar the other
  architectures are held to (#424).
- MIPS (32-bit o32) support, in both byte orders (#448) -- big-endian is as widely
  deployed as little-endian on this architecture, so both are read. Two things
  about it are unlike the other architectures and are handled without the rest of
  the engine having to know: a call names no target, going through the GOT
  instead, and a branch or call takes effect one instruction late, so what follows
  it runs first.
- Reading a libc that ships without section headers, as an embedded one commonly
  does -- OpenWrt strips them from musl to save flash (#432). Nothing is missing
  from such a file, so the symbols are read through `PT_DYNAMIC` and the code is
  disassembled as raw bytes. Every architecture reports the same gadgets as the
  same libc with its sections intact.
- A terminal `posix_spawn` whose symbol carries no version marker, as musl's does
  not, is no longer passed over (#432).

### Changed

- The gem no longer carries gadgets for the three glibc 2.26 builds it shipped
  (#443). What it carries is the glibc of every Ubuntu LTS in standard support
  plus the libcs the specs run against, and 2.26 is neither of those any more; a
  lookup by one of those BuildIDs now answers from the remote database. The
  entries themselves stay in the repository, as every unshipped build does.
- The scan locating calls in a libc's bytes asks a word what it could be before
  decoding it (#456), and the MIPS one keeps what a GOT slot answered. About 5%
  off an arm or MIPS search.
- Searching the same file twice in one process answers the second time from what
  the first found (#455), as reading its disassembly already did. The specs search 29
  libcs 76 times between them, which is 34s of work rather than 21s.
- A search no longer asks objdump which targets it supports once per command it
  builds, nor rebuilds the pattern naming a call mnemonic for every line it
  reads (#454). Roughly a tenth off a search (aarch64 glibc 2.43: 0.53s to 0.47s).
- Searching a MIPS libc now reads only the code around its calls (#453), rather
  than disassembling the whole file: 1.9s to 0.7s for the mipsel glibc fixture and
  2.3s to 0.7s for the musl ones. The gadgets reported are unchanged.
- Requires elftools >= 2.1.0 (#442), whose faster symbol-table read takes the
  search of a libc with no section headers from 1.11s to 0.68s -- the read
  itself from 0.51s to 0.17s. A libc that still has its sections is unaffected.

### Fixed

- arm found nothing at all in a libc with no section headers (#441). Three
  things were in the way: objdump has no mapping symbols to switch instruction
  set on, so it read Thumb code as A32 -- each stretch is now disassembled as
  what the dynamic symbol table says it is, which also keeps the handful of
  genuinely A32 functions (`setcontext` and its kin) read correctly; a symbol's
  Thumb bit made every name in the table miss its address by one; and a
  literal-pool load went unresolved wherever objdump stated the address it
  points at without naming what is there.
- A libc with no section headers lost the calls at an address its symbol table
  gives more than one name, such as glibc's `sigaction`/`__sigaction` (#440).
  The name written beside such an address is now the one the emulator acts on,
  and 20 aarch64 gadgets come back.
- A libc with no section headers reported fewer gadgets than the same libc
  intact on aarch64 and RISC-V (#439). Naming the targets in a raw disassembly
  covered only the shape amd64 prints, so a target separated by a comma, or
  followed by the note objdump appends to name a mnemonic's alias, went unnamed
  and the control-flow walk lost every edge through it -- 84 gadgets across the
  fixture corpus.
- amd64 threw away every candidate whose terminal call was not `execve` or
  `posix_spawn` before emulating it -- 10 to 30 `execl` windows per libc, a call
  one_gadget knows how to resolve (#434). They are emulated now. No libc in the
  test corpus reports a new gadget as a result, but one could.
- A search could abort with `TypeError` where it should have dropped the
  candidate, when a window added an unknown value to a register already holding
  a known one (#434).

## v2.0.0 - 2026-08-29

Reported gadgets are not offset-for-offset comparable with 1.x: constraints are
more precise, an output level means one thing everywhere, and every gadget the
test corpus reports has been run under a debugger and seen to spawn a shell.

### Added

- ARM32 support, alongside the existing amd64, i386 and aarch64 (#316).
- Output level 2, which lists every gadget including the ones lower levels drop
  as duplicate or harder-to-satisfy (#350). `--level` is documented in the
  README with what each level shows (#397).
- Aletheia, a verification harness that loads a libc under gdb (natively or
  through qemu-user), applies a constraint-satisfying plan, and requires a real
  shell to run `ls /` before a gadget counts as real (#399). Run it with
  `rake "aletheia:verify[level, target]"`. Every gadget the fixtures report is
  verified this way.
- Gadgets say which file descriptors they close on the way to the exec, so a
  reader knows when the spawned shell would lose its I/O (#371).
- `rake builds:refresh` rebuilds the shipped gadget database from what the
  Ubuntu archive publishes now, and `rake builds:check` fails when a shipped
  entry has gone stale -- at most once a week, never on CI (#405, #406).
- posix_spawn gadgets on aarch64 (#317), and the string a gadget reaches
  through the GOT is shown rather than left opaque (#372).

### Changed

- **The gem ships a curated gadget database.** It carries the glibc of every
  Ubuntu LTS in standard support plus every libc the tests cover -- 33 entries,
  taking the packaged gem from 3.4MB to 112KB. Any other BuildID is fetched from
  this repository on demand, as before, so nothing is unreachable; but an
  offline `-b` for an arbitrary libc no longer answers from the gem alone
  (#405).
- **An output level means the same thing however a libc is looked up.** `-b`
  now honours `--level`, where it previously handed back whatever the database
  stored, and level 1 picks the same gadget however the emulator happened to
  find it (#402).
- The database was regenerated; entries had been built before a year of
  constraint work and reported gadgets their libc no longer produces (#405).
- Constraints read consistently: pointers compare to `NULL` and values to hex,
  never a bare `0` (#334), and readability is stated as `readable: <reg>`
  (#344). A mask a gadget applies is named rather than given up on (#370), and
  a value required to be zero scores the same however it is spelled (#377,
  #401).
- Emulation stops at the terminal `exec*` call instead of running past it
  (#325), and a candidate whose path cannot hold is rejected (#359, #360).
- Searching a libc got roughly five times faster: the test corpus at level 0
  went from 42.5s to 8.6s (#388, #389, #390, #393, #394, #395, #396).
- Requires Ruby >= 3.3 (#293) and elftools >= 2.0.0.

### Fixed

- Gadgets that could not actually spawn a shell, each found by running them:
  a dereferenced pointer argument of a "safe" libc call went unconstrained
  (#323, #340), a writable constraint was lost when its base was reassigned
  (#341), frame-pointer stores did not require the frame be writable (#345),
  an argv that disables shell execution was reported as usable (#348), an
  uncontrolled dereference was not required to be readable (#354), and a slot
  was read back as its entry value rather than what the gadget had put there
  (#364).
- A GOT-base register the window establishes itself was seeded as a
  precondition (#385), and the GOT-base constraint is now only stated where a
  caller can actually put it -- in a register (#404).
- Windowed disassembly lost gadgets whose branch predecessor sits after the
  call, and could invent gadgets by falling through a window boundary (#391,
  #392).
- The "not glibc" check did not fire for aarch64 files (#311).
- **Certificates are verified again when fetching a gadget database entry.**
  Verification had been switched off, and what comes back from that request is
  written to a file and required as Ruby, so anyone able to answer it could run
  code as the user.
- Shipped entries reported fewer gadgets than reading the same libc as a file,
  having been generated before the emulator learned to run `xchg`. They are
  regenerated, and `rake builds:audit` now fails when an entry stops matching
  its libc.
- An architecture is recognised by the machine type its ELF header states, not
  by the name the reader library prints for it -- the latter is that library's
  wording and changed in elftools 2.0.0, which left every aarch64 and amd64 file
  reading as an unknown architecture.

## v1.10.0 - 2024-10-04

- Added JSON output, `--output-format json` (#225).
- Requires Ruby >= 3.1 (#216).

## v1.9.0 - 2023-11-30

- Sharper constraints for `argv` and `envp` (#206).
- Added `--dwarf-start=0` so the output carries no local file path (#205).

## v1.8.1 - 2022-03-25

- Stack registers score higher on writable constraints, so easier gadgets rank
  first (#190).

## v1.8.0 - 2022-03-20

- posix_spawn call sites are treated as one-gadgets (#183).
- amd64: loosened the restriction on gadgets reached by `jmp` (#178).

## v1.7.4 - 2021-01-13

- Writable constraints on the x86 architectures (#156).

## v1.7.3 - 2019-10-25

- Added the `--base` option (#100).
- Constraints for XMM alignment, and stack alignment scores higher (#87).

## v1.7.2 - 2019-05-05

- Added `--near`, ordering gadgets by distance from given functions (#76).
- Introduced the CLI module (#81).

## v1.7.1 - 2019-04-19

- Added gemspec metadata (#75).

## v1.7.0 - 2019-03-07

- AArch64 support (#64).
- Constraints are scored, so the easiest gadgets are reported first (#67).

## v1.6.2 - 2018-10-25

- one_gadget is usable as a library (#47).

## v1.6.1 - 2018-09-13

- Improved update checking (#43) and custom error classes (#40).

## v1.6.0 - 2018-04-28

- Added the xmm instructions and glibc 2.27 builds (#27).
- Added `--info`, showing what is known about a BuildID (#25).

## v1.5.0 - 2017-11-06

- Emulator rework, and the build database is generated from libc files (#15).

## v1.4.1 - 2017-11-01

- Checks for a newer version automatically (#13).

## v1.4.0 - 2017-06-23

- Warns when a BuildID is not found, and added Ubuntu 16.04/17.04 libcs (#9).

## v1.3.8 - 2017-05-26

- `one_gadget()` simplified for use from a script.

## v1.3.7 - 2017-04-04

- Added the gem version option, and 256-colour output.

## v1.3.6 - 2017-04-01

- Added builds for glibc >= 2.19; a given libc file is no longer looked up
  remotely (#6).

## v1.3.5 - 2017-03-27

- Raises a clear error for an unknown architecture.

## v1.3.4.1 - 2017-03-22

- Fixed running on Ruby 2.1.

## v1.3.4 - 2017-03-21

- Fixed failure on libc-2.15; switched to optparse.

## v1.3.3 - 2017-03-16

- Reads ELF files with rbelftools instead of shelling out to binutils/readelf.

## v1.3.2 - 2017-03-07

- ANSI colour output, and `one_gadget()` for use from Ruby.

## v1.3.1 - 2017-02-21

- Unrecognised instructions are handled instead of aborting the search.

## v1.3.0 - 2017-02-21

- amd64: consider the `jmp` case.

## v1.2.0 - 2017-02-17

- Introduced the instruction and lambda emulator objects.

## v1.1.1 - 2017-02-14

- Added gadgets for more libcs.

## v1.1.0 - 2017-02-13

- i386 support.

## v1.0.0 - 2017-02-12

- Gadget database fetched from the repository when a BuildID is not shipped.

## v0.1.0 - 2017-02-11

- First release.
