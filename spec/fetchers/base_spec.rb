# frozen_string_literal: true

require 'one_gadget/emulators/amd64'
require 'one_gadget/emulators/lambda'
require 'one_gadget/fetchers/amd64'

describe OneGadget::Fetcher::Base do
  # Allocate without #initialize so no libc file / objdump is needed; these
  # tests only exercise the arch-independent private helpers of Base.
  let(:fetcher) { OneGadget::Fetcher::Amd64.allocate }
  let(:processor) { OneGadget::Emulators::Amd64.new }

  describe '#check_stack_argv' do
    # The argv pointer lives on the stack and every argv[i] happens to be a
    # stack register, so the constraint must mention both the argv pointer
    # (argv_ptr) and argv[0] being NULL.
    it 'constrains the argv pointer and argv[0] when argv is all stack registers' do
      stack = processor.get_corresponding_stack('rsp')
      [0, 8, 16, 24].each { |off| stack[off] = OneGadget::Emulators::Lambda.new('rbp') }
      lmda = OneGadget::Emulators::Lambda.parse('rsp')

      result = fetcher.send(:check_stack_argv, processor, 'rsp', lmda, true)
      expect(result).to eq('rsp == NULL || rbp == NULL || {rbp, rbp, rbp, rbp, ...} is a valid argv')
    end
  end

  describe '#check_envp' do
    # envp is a bare stack register (deref_count == 0), the "just in case"
    # branch that reads the envp array off the stack.
    it 'yields a valid-envp constraint when envp is a stack register' do
      yielded = nil
      ret = fetcher.send(:check_envp, processor, 'rsp') { |cons| yielded = cons }

      expect(ret).to be_truthy
      expect(yielded).to match(/\Arsp == NULL \|\| \{.*\} is a valid envp\z/)
    end
  end
end
