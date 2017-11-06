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
    -l, --level OUTPUT_LEVEL         The output level.
                                     OneGadget automatically selects gadgets with higher successful probability.
                                     Increase this level to ask OneGadget show more gadgets it found.
                                     Default: 0
    -r, --[no-]raw                   Output gadgets offset only, split with one space.
    -s, --script exploit-script      Run exploit script with all possible gadgets.
                                     The script will be run as 'exploit-script $offset'.
        --version                    Current gem version.
    EOS
  end
end
