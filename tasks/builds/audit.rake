# frozen_string_literal: true

namespace :builds do
  desc 'Fails when a shipped entry no longer says what emulating its libc says'
  # A build file is generated output, so a change to what the emulator reports
  # leaves it describing gadgets the code no longer produces -- and a BuildID
  # lookup then answers differently from the same libc read as a file. Only the
  # entries whose libc is in the repository can be asked; the rest are checked by
  # regenerating them (see builds:refresh).
  task :audit do
    # Skipped on CI for the same reason as builds:check (whose +ci?+ this shares):
    # answering it means regenerating and committing the entries, which happens in
    # a checkout rather than in a build.
    next puts 'builds:audit: skipped on CI' if ci?

    require 'one_gadget'

    checked = 0
    drifted = Dir.glob(File.join(repo_root, 'spec', 'data', '*.so')).filter_map do |libc|
      id = OneGadget::Helper.build_id_of(libc)
      stored = id && OneGadget::Fetchers.from_build_id(id, remote: false, level: OneGadget::Fetchers::RAW_LEVEL)
      next if stored.nil?

      checked += 1
      fresh = OneGadget::Fetchers.from_file(libc, level: OneGadget::Fetchers::RAW_LEVEL)
      next if described(stored) == described(fresh)

      "  #{File.basename(libc)}: entry has #{stored.size} gadgets, the libc reports #{fresh.size}"
    end

    puts "builds:audit: #{checked} shipped #{checked == 1 ? 'entry' : 'entries'} match their libc" if drifted.empty?
    raise <<~MSG unless drifted.empty?
      Shipped entries no longer match what emulating their libc reports:
      #{drifted.join("\n")}
      Regenerate them with:
        bundle exec rake builds:refresh
    MSG
  end
end

# Everything a build file records about a gadget, so a difference in any of it
# counts as drift.
# @param [Array<OneGadget::Gadget::Gadget>] gadgets
# @return [Array<Array>]
def described(gadgets)
  gadgets.map { |g| [g.offset, g.constraints, g.effect, g.closed_fds] }
end
