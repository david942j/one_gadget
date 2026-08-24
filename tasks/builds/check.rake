# frozen_string_literal: true

require 'json'

# How long an answer from the archive is trusted before asking it again. The
# question costs a network round trip per release and architecture, and glibc
# point releases land weeks apart, so asking once a week is plenty.
ARCHIVE_CHECK_INTERVAL = 7 * 24 * 60 * 60

namespace :builds do
  desc 'Fails when Ubuntu publishes a newer libc6 than the shipped entries were built from'
  # Shares its knowledge of the archive with builds:refresh (tasks/builds/refresh.rake).
  task :check do
    # A checkout has no say in when the database is refreshed, and a build should
    # not start failing because a distribution shipped a security update.
    next puts 'builds:check: skipped on CI' if ci?

    wanted = archive_debs
    next warn 'builds:check: could not reach the archive, skipping' if wanted.nil?

    # Recomputed against the build files every run, from the cached answer: the
    # moment a refresh lands this passes, and until then it keeps saying so
    # without asking the archive again.
    stale = wanted.reject { |_target, deb| shipped_debs.include?(deb) }
    next if stale.empty?

    raise <<~MSG
      Ubuntu publishes a newer libc6 than #{stale.size} shipped #{stale.size == 1 ? 'entry was' : 'entries were'} built from:
      #{stale.map { |target, deb| "  #{target.ljust(14)} #{deb}" }.join("\n")}
      Rebuild them with:
        bundle exec rake builds:refresh
      (the whole task, not builds:refresh[lts] -- a new libc has a new BuildID,
      and only a full run rewrites the shipped_builds manifest to name it)
    MSG
  end
end

# @return [Boolean] Whether this is running somewhere nobody can act on the answer.
def ci?
  !ENV.fetch('CI', '').empty?
end

# The libc6 package each LTS release and architecture currently publishes, as the
# +.deb+ file name a build file records itself as coming from. Answered from the
# cache while it is fresh (see {ARCHIVE_CHECK_INTERVAL}), so the network is asked
# at most once a week however often the task runs.
# @return [Hash{String => String}, nil] +nil+ when the archive cannot be reached.
def archive_debs
  cached = read_check_cache
  return cached['debs'] if cached && Time.now.to_i - cached['checked_at'] < ARCHIVE_CHECK_INTERVAL

  debs = UBUNTU_LTS.product(UBUNTU_MIRRORS.keys).to_h do |release, arch|
    package = latest_libc6(release, arch)
    ["#{release}/#{arch}", package && File.basename(package[:url])]
  end.compact
  return nil if debs.empty?

  write_check_cache(debs)
  debs
end

def check_cache_path
  File.join(download_cache, 'archive-check.json')
end

# @return [Hash, nil] +nil+ when there is no readable cache to answer from.
def read_check_cache
  JSON.parse(File.read(check_cache_path))
rescue StandardError
  nil
end

def write_check_cache(debs)
  File.write(check_cache_path, JSON.generate({ 'checked_at' => Time.now.to_i, 'debs' => debs }))
end

# The package every shipped entry was built from, for the entries built from one
# (a fixture records its path in the repository instead).
# @return [Array<String>]
def shipped_debs
  @shipped_debs ||= File.readlines(File.join(repo_root, 'shipped_builds'), chomp: true).filter_map do |name|
    # The source is the build file's first comment, well inside the first chunk.
    File.read(File.join(repo_root, 'lib', 'one_gadget', 'builds', "#{name}.rb"), 512)[/libc6_\S+\.deb/]
  end
end
