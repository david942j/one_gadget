# frozen_string_literal: true

module OneGadget
  module Emulators
    # Arch-independent catalog of libc calls the emulator accepts without
    # executing them (see {Processor#dispatch_safe_call} for how an entry's
    # per-argument requirements are applied and what each requirement symbol
    # means). These functions -- syscall wrappers and +posix_spawn+'s setup
    # helpers -- have identical semantics on every architecture, so their
    # requirements live here once instead of being copied into each arch's
    # emulator. Centralising them keeps the arches from drifting: a duplicated
    # +posix_spawn+ table once let x86 gain a +setsigmask+ constraint that
    # arm/aarch64 silently lacked, so gadgets entering before that call were
    # emitted without the precondition they need.
    #
    # An arch merges its own extra/overriding entries on top (see
    # {X86::SAFE_CALLS}, {ArmFamily::SAFE_CALLS}). Order matters: the specific
    # +posix_spawnattr_setsigmask+/+setsigdefault+ keys precede the generic
    # +posix_spawnattr_+ prefix so a substring match resolves to them first.
    module SafeCalls
      # @return [Hash{String => Hash{Integer => Symbol}}]
      #   Function name (or name prefix) => argument index => requirement.
      # @example +posix_spawnattr_setsigmask(attr, set)+ runs +attr->__ss = *set+
      #   so +set+ (arg 1) must be readable and +attr+ (arg 0) writable.
      COMMON = {
        # sigprocmask dereferences its set argument unless it is NULL, which glibc
        # guards with an explicit NULL check (and still reaches the call on the
        # NULL path).
        'sigprocmask' => { 1 => :nullable_deref },
        # setsigmask/setsigdefault copy *set into the attr unconditionally, so the
        # source (arg 1) must be readable and the attr they write (arg 0) writable.
        'posix_spawnattr_setsigmask' => { 0 => :writable, 1 => :deref },
        'posix_spawnattr_setsigdefault' => { 0 => :writable, 1 => :deref },
        # every other setup helper writes its attr / file-actions object (arg 0).
        'posix_spawnattr_' => { 0 => :writable },
        'posix_spawn_file_actions_' => { 0 => :writable }
      }.freeze
    end
  end
end
