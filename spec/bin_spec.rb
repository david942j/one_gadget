describe 'Binary' do
  before(:all) do
    @bin = File.join(__dir__, '..', 'bin', 'one_gadget')
    @lib = File.join(__dir__, '..', 'lib')
  end

  it 'help' do
    expect(`env ruby -I#{@lib} #{@bin}`).to eq <<-EOS
Usage: one_gadget [file] [options]
    -b, --build-id BuildID           BuildID[sha1] of libc.
    -f, --[no-]force-file            Force search gadgets in file instead of build id first.
    -n, --near FUNCTIONS/FILE        Order gadgets by their distance to the given functions or to the GOT functions of the given file.
    -l, --level OUTPUT_LEVEL         The output level.
                                     OneGadget automatically selects gadgets with higher successful probability.
                                     Increase this level to ask OneGadget show more gadgets it found.
                                     Default: 0
    -r, --[no-]raw                   Output gadgets offset only, split with one space.
    -s, --script exploit-script      Run exploit script with all possible gadgets.
                                     The script will be run as 'exploit-script $offset'.
        --info BuildID               Show version information given BuildID.
        --version                    Current gem version.
    EOS
  end

  context 'near' do
    before do
      skip_unless_objdump
    end

    it 'functions' do
      file = data_path('libc-2.24-8cba3297f538691eb1875be62986993c004f3f4d.so')
      expect(`env ruby -I#{@lib} #{@bin} -n system -l 1 #{file}`).to eq <<-EOS
[OneGadget] Gadgets near system(0x3f4d0):
0x3f3aa execve("/bin/sh", rsp+0x30, environ)
constraints:
  [rsp+0x30] == NULL

0x3f356 execve("/bin/sh", rsp+0x30, environ)
constraints:
  rax == NULL

0xb8a38 execve("/bin/sh", r13, r12)
constraints:
  [r13] == NULL || r13 == NULL
  [r12] == NULL || r12 == NULL

0xd67e5 execve("/bin/sh", rsp+0x70, environ)
constraints:
  [rsp+0x70] == NULL

0xd67f1 execve("/bin/sh", rsi, [rax])
constraints:
  [rsi] == NULL || rsi == NULL
  [[rax]] == NULL || [rax] == NULL

      EOS
    end

    it 'functions' do
      file = data_path('libc-2.24-8cba3297f538691eb1875be62986993c004f3f4d.so')
      expect(`env ruby -I#{@lib} #{@bin} -n wscanf,pwrite -l 1 -r #{file}`).to eq <<-EOS
[OneGadget] Gadgets near pwrite(0xd9b70):
878577 878565 756280 258986 258902

[OneGadget] Gadgets near wscanf(0x6afe0):
258986 258902 756280 878565 878577

      EOS
    end

    it 'file' do
      bin_file = data_path('test_near_file.elf')
      lib_file = data_path('libc-2.24-8cba3297f538691eb1875be62986993c004f3f4d.so')
      expect(`env ruby -I#{@lib} #{@bin} -n #{bin_file} -l 1 -r #{lib_file}`).to eq <<-EOS
[OneGadget] Gadgets near exit(0x359d0):
258902 258986 756280 878565 878577

[OneGadget] Gadgets near puts(0x68fe0):
258986 258902 756280 878565 878577

[OneGadget] Gadgets near printf(0x4f1e0):
258986 258902 756280 878565 878577

[OneGadget] Gadgets near strlen(0x80420):
756280 258986 258902 878565 878577

[OneGadget] Gadgets near __cxa_finalize(0x35c70):
258902 258986 756280 878565 878577

[OneGadget] Gadgets near __libc_start_main(0x201a0):
258902 258986 756280 878565 878577

      EOS
    end
  end
end
