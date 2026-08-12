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
        '__sigaction' => { 1 => :nullable_deref, 2 => :null },
        # Record the descriptor __close closes: which one it is decides whether the
        # spawned shell keeps its I/O (see {Processor#note_closed_fd}).
        '__close' => { 0 => :closed_fd },
        # unsetenv reads its name (arg 0); +:global_var?+ may over-constrain it
        # (readable would suffice), but no current fixture reaches unsetenv near an
        # exec to verify -- left as-is.
        'unsetenv' => { 0 => :global_var? },
        # setsigmask/setsigdefault copy *set into the attr unconditionally, so the
        # source (arg 1) must be readable and the attr they write (arg 0) writable.
        'posix_spawnattr_setsigmask' => { 0 => :writable, 1 => :deref },
        'posix_spawnattr_setsigdefault' => { 0 => :writable, 1 => :deref },
        # every other attr setup helper writes its attr object (arg 0).
        'posix_spawnattr_' => { 0 => :writable }
        # posix_spawn_file_actions_* helpers are deliberately absent, so a candidate
        # that calls one is aborted (see {Processor#dispatch_safe_call}) rather than
        # walked through. Accepting them would need a model out of reach today:
        #   * the helper returns 0 only when its fd argument is a valid fd
        #     (0 <= fd < INT_MAX), and the caller branches on that return -- a nonzero
        #     result skips the following +posix_spawn+ -- so treating the call as
        #     always succeeding emits a gadget whose reachability doesn't actually hold;
        #   * appending the action grows +__actions+ via +realloc+, which can fail
        #     (ENOMEM) or fault on a bogus object -- not guaranteeable from a symbolic
        #     writable pointer;
        #   * +posix_spawn_file_actions_t+ is a glibc-internal, version-dependent
        #     layout, so modeling its fields soundly across libc versions is fragile;
        #   * and a successful call injects a close/open/dup2 into the spawned child
        #     whose harmlessness depends on the fd, which isn't expressible.
      }.freeze
    end
  end
end
