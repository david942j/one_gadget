# frozen_string_literal: true

require 'optparse'

require 'one_gadget/logger'
require 'one_gadget/one_gadget'
require 'one_gadget/version'

module OneGadget
  # Methods for command lint interface.
  module CLI
    # Help message.
    USAGE = 'Usage: one_gadget <FILE|-b BuildID> [options]'

    module_function

    # Main method of CLI.
    # @param [Array<String>] argv
    #   Command line arguments.
    # @return [void]
    # @example
    #   CLI.work(%w[--help])
    #   #=> # usage message
    #   CLI.work(%w[--version])
    #   #=> # version message
    def work(argv)
      @options = { raw: false, level: 0 }
      parser.parse!(argv)
      # handles --version
      return show("OneGadget Version #{OneGadget::VERSION}") if @options[:version]
      return info_build_id(@options[:info]) if @options[:info]

      libc_file = argv.pop
      build_id = @options[:build_id]
      level = @options[:level]
      return error("Either FILE or BuildID can be passed\n") if libc_file && @options[:build_id]
      return show(parser.help) && false unless build_id || libc_file

      gadgets = if build_id
                  OneGadget.gadgets(build_id: build_id, details: true, level: level)
                else # libc_file
                  OneGadget.gadgets(file: libc_file, details: true, force_file: @options[:force_file], level: level)
                end
      return handle_script(gadgets, @options[:script]) if @options[:script]
      return handle_near(libc_file, gadgets, @options[:near]) if libc_file && @options[:near]

      display_gadgets(gadgets, @options[:raw])
      true
    end

    # Display libc information given BuildID.
    # @param [String] id
    # @return [Boolean]
    # @example
    #   CLI.info_build_id('b417c')
    #   # [OneGadget] Information of b417c:
    #   #             spec/data/libc-2.27-b417c0ba7cc5cf06d1d1bed6652cedb9253c60d0.so
    #   #
    #   #             Advanced Micro Devices X86-64
    #   #
    #   #             GNU C Library (Ubuntu GLIBC 2.27-3ubuntu1) stable release version 2.27.
    #   #             Copyright (C) 2018 Free Software Foundation, Inc.
    #   #             This is free software; see the source for copying conditions.
    #   #             There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
    #   #             PARTICULAR PURPOSE.
    #   #             Compiled by GNU CC version 7.3.0.
    #   #             libc ABIs: UNIQUE IFUNC
    #   #             For bug reporting instructions, please see:
    #   #             <https://bugs.launchpad.net/ubuntu/+source/glibc/+bugs>.
    #   #=> true
    def info_build_id(id)
      result = OneGadget::Gadget.builds_info(id)
      return false if result.nil? # invalid form or BuildID not found

      OneGadget::Logger.info("Information of #{id}:\n#{result.join("\n")}\n")
      true
    end

    # The option parser.
    # @return [OptionParser]
    def parser
      @parser ||= OptionParser.new do |opts|
        opts.banner = USAGE

        opts.on('-b', '--build-id BuildID', 'BuildID[sha1] of libc.') do |b|
          @options[:build_id] = b
        end

        opts.on('-f', '--[no-]force-file', 'Force search gadgets in file instead of build id first.') do |b|
          @options[:force_file] = b
        end

        opts.on('-l', '--level OUTPUT_LEVEL', Integer, 'The output level.',
                'OneGadget automatically selects gadgets with higher successful probability.',
                'Increase this level to ask OneGadget show more gadgets it found.',
                'Default: 0') do |l|
          @options[:level] = l
        end

        opts.on('-n', '--near FUNCTIONS/FILE', 'Order gadgets by their distance to the given functions'\
                ' or to the GOT functions of the given file.') do |n|
          @options[:near] = n
        end

        opts.on('-r', '--[no-]raw', 'Output gadgets offset only, split with one space.') do |v|
          @options[:raw] = v
        end

        opts.on('-s', '--script exploit-script', 'Run exploit script with all possible gadgets.',
                'The script will be run as \'exploit-script $offset\'.') do |script|
          @options[:script] = script
        end

        opts.on('--info BuildID', 'Show version information given BuildID.') do |b|
          @options[:info] = b
        end

        opts.on('--version', 'Current gem version.') do |v|
          @options[:version] = v
        end
      end
    end

    # Writes +msg+ to stdout and returns +true+.
    # @param [String] msg
    # @return [true]
    def show(msg)
      puts msg
      true
    end

    # Forks and executes the command.
    # @param [String] cmd
    # @return [void]
    def execute(cmd)
      Process.wait(spawn(cmd))
    end

    # Handle the --script feature.
    # @param [Array<OneGadget::Gadget::Gadget>] gadgets
    # @param [String] script
    # @return [true]
    def handle_script(gadgets, script)
      gadgets.map(&:offset).each do |offset|
        OneGadget::Logger.info("Trying #{OneGadget::Helper.colored_hex(offset)}...\n")
        execute("#{script} #{offset}")
      end
      true
    end

    # @param [Array<OneGadget::Gadget::Gadget>] gadgets
    # @param [Boolean] raw
    # @return [void]
    def display_gadgets(gadgets, raw)
      if raw
        puts gadgets.map(&:offset).join(' ')
      else
        puts gadgets.map(&:inspect).join("\n")
      end
    end

    # Log error.
    # @param [String] msg
    # @return [false]
    def error(msg)
      OneGadget::Logger.error(msg)
      false
    end

    # Implements the --near feature.
    # @param [String] libc_file
    # @param [Array<OneGadget::Gadget::Gadget>] gadgets
    # @param [String] near
    #   This can be name of functions or an ELF file.
    #   - Use one comma without spaces to specify a list of functions: +printf,scanf,free+.
    #   - Path to an ELF file and take its GOT functions to process: +/bin/ls+
    def handle_near(libc_file, gadgets, near)
      # TODO: show proper message for invalid +near+
      functions = if File.file?(near) && OneGadget::Helper.valid_elf_file?(near)
                    OneGadget::Helper.got_functions(near)
                  else
                    near.split(',').map(&:strip)
                  end
      function_offsets = OneGadget::Helper.function_offsets(libc_file, functions)
      function_offsets.each do |function, offset|
        colored_offset = OneGadget::Helper.colored_hex(offset)
        OneGadget::Logger.warn("Gadgets near #{OneGadget::Helper.colorize(function)}(#{colored_offset}):\n")
        display_gadgets(gadgets.sort_by { |gadget| (gadget.offset - offset).abs }, @options[:raw])
        puts "\n"
      end
      true
    end
  end
end
