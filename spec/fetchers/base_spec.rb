# frozen_string_literal: true

require 'one_gadget/emulators/amd64'
require 'one_gadget/emulators/lambda'
require 'one_gadget/fetchers/amd64'

describe OneGadget::Fetchers::Base do
  # Allocate without #initialize so no libc file / objdump is needed; these
  # tests only exercise the arch-independent private helpers of Base.
  let(:fetcher) { OneGadget::Fetchers::Amd64.allocate }
  let(:processor) { OneGadget::Emulators::Amd64.new }

  describe '#check_stack_argv' do
    # The argv pointer lives on the stack and every argv[i] happens to be a
    # stack register, so the constraint must mention both the argv pointer
    # (argv_ptr) and argv[0] being NULL.
    it 'constrains the argv pointer and argv[0] when argv is all stack registers' do
      stack = processor.get_corresponding_stack('rsp')
      [0, 8, 16, 24].each { |off| stack[off] = OneGadget::Emulators::Lambda.new('rbp') }
      lmda = OneGadget::Emulators::Lambda.parse('rsp')

      result = fetcher.send(:check_stack_argv, processor, lmda, true)
      expect(result).to eq('rsp == NULL || rbp == NULL || {rbp, rbp, rbp, rbp, ...} is a valid argv')
    end
  end

  describe '#predecessors' do
    # A windowed disassembly is a run of separate regions, so the line before the
    # first of a window is the last of the window before it -- a different part of
    # the binary, which nothing follows from.
    it 'does not fall through into the first line of a window' do
      allow(fetcher).to receive_messages(disasm_lines: ['1000: mov rax,rbx', '2000: mov rcx,rdx'],
                                         branch_pred_map: {})
      allow(fetcher).to receive(:window_starts).and_return({ 0 => true })
      expect(fetcher.send(:predecessors, 1)).to eq [[0, false]]

      fetcher.instance_variable_set(:@predecessors, nil)
      allow(fetcher).to receive(:window_starts).and_return({ 0 => true, 1 => true })
      expect(fetcher.send(:predecessors, 1)).to be_empty
    end
  end

  describe '#resolve_suffix' do
    # An exotic path can leave an argument register the resolver cannot evaluate,
    # which raises rather than returning nil; such a candidate simply isn't a gadget.
    it 'drops a candidate whose resolution raises' do
      allow(fetcher).to receive(:emulate).and_return(processor)
      allow(fetcher).to receive(:resolve).and_raise(OneGadget::Error::ArgumentError, 'unevaluable')
      expect(fetcher.send(:resolve_suffix, ['1000: nop'])).to be_nil
    end
  end

  describe '#noexec_shell_argv?' do
    # execve's program is always "/bin/sh", so argv[1] is that shell's option
    # word. A fixed "-n" (noexec) bundle parses input but runs nothing; "-c"
    # runs the command; a non-global (attacker-set) word imposes no such flag.
    it 'flags a noexec option word but not -c or a non-global word' do
      allow(fetcher).to receive(:global_str_content).and_return('-nc')
      expect(fetcher.send(:noexec_shell_argv?, ['"sh"', 'g', 'x', '0'])).to be true
      allow(fetcher).to receive(:global_str_content).and_return('-c')
      expect(fetcher.send(:noexec_shell_argv?, ['"sh"', 'g', 'x', '0'])).to be false
      allow(fetcher).to receive(:global_str_content).and_return(nil)
      expect(fetcher.send(:noexec_shell_argv?, ['"sh"', 'rbx', 'x', '0'])).to be false
    end
  end

  describe '#check_envp' do
    # envp is a bare stack register (deref_count == 0), the "just in case"
    # branch that reads the envp array off the stack.
    it 'yields a valid-envp constraint when envp is a stack register' do
      yielded = nil
      envp_ptr = OneGadget::Emulators::Lambda.new('rsp')
      ret = fetcher.send(:check_envp, processor, envp_ptr) { |cons| yielded = cons }

      expect(ret).to be_truthy
      expect(yielded).to match(/\Arsp == NULL \|\| \{.*\} is a valid envp\z/)
    end
  end

  # A branch comparing a value with itself (e.g. +cmp x0, x0+): "X == X" is always
  # true so the constraint is dropped; "X != X" never is, so the gadget is infeasible.
  describe '#tautology? / #contradiction?' do
    it 'classifies a self-comparison by its operator' do
      expect(fetcher.send(:tautology?, 'rax == rax')).to be true
      expect(fetcher.send(:tautology?, '(s64)x0 >= x0')).to be true
      expect(fetcher.send(:contradiction?, 'rax != rax')).to be true
      expect(fetcher.send(:contradiction?, 'x0 < x0')).to be true
    end

    it 'leaves genuine relations and disjunctions alone' do
      expect(fetcher.send(:tautology?, 'x2 == 0x1')).to be false
      expect(fetcher.send(:contradiction?, 'x2 == 0x1')).to be false
      expect(fetcher.send(:trivial_relation, '[rax] == NULL || rax == rax')).to be_nil
    end

    # Two sides that differ textually can still be settled: concrete values
    # compare directly, and one base against itself plus an offset never matches.
    it 'settles a relation whose sides are comparable without the caller' do
      expect(fetcher.send(:tautology?, '0x1 == 0x1')).to be true
      expect(fetcher.send(:contradiction?, '0x1 != 0x1')).to be true
      expect(fetcher.send(:contradiction?, 'r1 == r1+0x4')).to be true
      expect(fetcher.send(:tautology?, 'r1 != r1+0x4')).to be true
    end

    # Offsets from one base are comparable as addresses, but the values *at*
    # those addresses are not -- nothing says two stack slots differ.
    it 'leaves a comparison of two dereferenced slots alone' do
      expect(fetcher.send(:trivial_relation, '[r1] == [r1+0x4]')).to be_nil
    end
  end
end
