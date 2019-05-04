# frozen_string_literal: true

require 'one_gadget/emulators/instruction'
require 'one_gadget/error'

describe OneGadget::Emulators::Instruction do
  before(:all) do
    @mov = OneGadget::Emulators::Instruction.new('mov', 2)
    @add = OneGadget::Emulators::Instruction.new('add', 2)
    @lea = OneGadget::Emulators::Instruction.new('lea', 2)
    @call = OneGadget::Emulators::Instruction.new('call', 1)
  end

  it 'match?' do
    expect(@add.match?('add rax, rax')).to be true
    expect(@add.match?('41f11:       addr32 call c4590 <execve>')).to be false
    expect(@call.match?('41f11:       addr32 call c4590 <execve>')).to be true
  end

  it 'fetch_args' do
    expect(@mov.fetch_args(<<-'EOS')).to eq ['rax', '[rip+0x2c16b4]']
      d67e5:       48 8b 05 b4 16 2c 00    mov    rax,QWORD PTR [rip+0x2c16b4]        # 397ea0 <_DYNAMIC+0x340>
    EOS
    expect(@mov.fetch_args(<<-'EOS')).to eq ['rdx', '[rax]']
      d67f8:       48 8b 10                mov    rdx,QWORD PTR [rax]
    EOS
    expect { @mov.fetch_args('mov a, b, c') }.to raise_error(OneGadget::Error::InstructionArgumentError)
    expect(@lea.fetch_args(<<-'EOS')).to eq ['rsi', '[rsp+0x70]']
      d67ec:       48 8d 74 24 70          lea    rsi,[rsp+0x70]
    EOS
    expect(@lea.fetch_args(<<-'EOS')).to eq ['rdi', '[rip+0x8ab61]']
      d67f1:       48 8d 3d 61 ab 08 00    lea    rdi,[rip+0x8ab61]        # 161359 <_nl_POSIX_name+0x154>
    EOS
    expect(@call.fetch_args(<<-'EOS')).to eq ['b8470 <execve>']
      d67fb:       e8 70 1c fe ff          call   b8470 <execve>
    EOS
  end
end
