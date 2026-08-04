# frozen_string_literal: true

module OneGadget
  module Emulators
    # Arch-independent catalog of libc calls the emulator accepts without
    # executing them (see {Processor#dispatch_safe_call} for how an entry's
    # per-argument requirements are applied and what each requirement symbol
    # means). These functions -- syscall wrappers and +posix_spawn+'s setup
    # helpers -- have identical semantics on every architecture, so their
    # requirements live here once instead of being copied into each arch's
    # emulator, keeping the arches from drifting.
    #
    # Order matters: the first key that is a substring of the call symbol wins, so
    # the specific +posix_spawnattr_setsigmask+/+setsigdefault+ keys precede the
    # generic +posix_spawnattr_+ prefix.
    module SafeCalls
      # @return [Hash{String => Hash{Integer => Symbol}}]
      #   Function name (or name prefix) => argument index => requirement.
      COMMON = {
        # sigprocmask/__sigaction dereference a pointer arg unless it is NULL, which
        # glibc guards with an explicit NULL check (and still reaches the call on the
        # NULL path): sigprocmask's +set+ and __sigaction's +act+ (both arg 1).
        # __sigaction also writes back through +oldact+ (arg 2), so oldact must be NULL.
        'sigprocmask' => { 1 => :nullable_deref },
        '__sigaction' => { 1 => :nullable_deref, 2 => :zero? },
        # __close takes no pointer argument (nothing to constrain). unsetenv reads its
        # name (arg 0); +:global_var?+ may over-constrain it (readable would suffice),
        # but no current fixture reaches unsetenv near an exec to verify -- left as-is.
        '__close' => {},
        'unsetenv' => { 0 => :global_var? },
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
