# frozen_string_literal: true

# What the helpers below need; +one_gadget+ itself is asked for by the task that
# emulates, so merely checking the archive does not pay for loading it.
require 'fileutils'
require 'shellwords'
require 'zlib'

# The libcs the gem carries gadgets for: the glibc of every Ubuntu LTS still in
# standard support, plus every libc the specs run against -- those are the ones
# Aletheia verifies gadget by gadget, so they are the best-evidenced entries we
# have. Everything else stays in the repository for a remote lookup to find.
UBUNTU_LTS = %w[noble jammy focal].freeze
UBUNTU_MIRRORS = {
  'amd64' => 'http://archive.ubuntu.com/ubuntu',
  'i386' => 'http://archive.ubuntu.com/ubuntu',
  'arm64' => 'http://ports.ubuntu.com/ubuntu-ports',
  'armhf' => 'http://ports.ubuntu.com/ubuntu-ports'
}.freeze
# A glibc security fix is published to one pocket or the other, so ask both and
# keep whichever answer is newer.
UBUNTU_POCKETS = %w[-updates -security].freeze

namespace :builds do
  desc 'Regenerates the shipped build database from Ubuntu LTS libcs and the spec fixtures'
  # bundle exec rake builds:refresh
  # bundle exec rake "builds:refresh[spec]"
  task :refresh, :scope do |_t, args|
    require 'elftools'
    require 'one_gadget'

    scope = args.scope || 'all'
    raise "unknown scope #{scope.inspect}, expected all, lts or spec" unless %w[all lts spec].include?(scope)

    shipped = []
    shipped.concat(refresh_lts) unless scope == 'spec'
    shipped.concat(refresh_fixtures) unless scope == 'lts'
    if scope == 'all'
      File.write(File.join(repo_root, 'shipped_builds'), "#{shipped.sort.uniq.join("\n")}\n")
      puts "shipped_builds lists #{shipped.uniq.size} entries"
    else
      puts "partial scope, left shipped_builds alone (#{shipped.size} entries regenerated)"
    end
    Rake::Task['builds:list'].invoke
  end
end

def repo_root
  File.expand_path(File.join(__dir__, '..', '..'))
end

# Where downloaded packages and the libcs unpacked out of them are kept, so a
# re-run costs nothing.
def download_cache
  File.join(repo_root, 'libcs').tap { |dir| FileUtils.mkdir_p(dir) }
end

def refresh_lts
  UBUNTU_LTS.product(UBUNTU_MIRRORS.keys).filter_map do |release, arch|
    package = latest_libc6(release, arch)
    next warn("skip #{release}/#{arch}: libc6 not published") if package.nil?

    print "[#{release}/#{arch}] #{package[:version]} .. "
    libc = unpack_libc(package, release, arch)
    next puts('fail: no libc in the package') if libc.nil?

    regenerate(libc, package[:url])
  end
end

def refresh_fixtures
  Dir.glob(File.join(repo_root, 'spec', 'data', '*.so')).filter_map do |libc|
    print "[spec] #{File.basename(libc)} .. "
    regenerate(libc, File.join('spec', 'data', File.basename(libc)))
  end
end

# The libc6 the archive currently publishes for a release, as a +Packages+
# stanza reduced to what fetching it needs.
# @return [Hash?] +nil+ when no pocket publishes libc6 for this pair.
def latest_libc6(release, arch)
  mirror = UBUNTU_MIRRORS.fetch(arch)
  UBUNTU_POCKETS.filter_map { |pocket| libc6_stanza(mirror, "#{release}#{pocket}", arch) }
                .reduce(nil) { |best, cur| best.nil? || newer?(cur[:version], best[:version]) ? cur : best }
end

def libc6_stanza(mirror, suite, arch)
  # Always re-read the index: it is the thing that says what is current, and a
  # kept copy would answer with whatever was published when it was fetched. The
  # packages it points at are immutable and stay cached.
  index = download("#{mirror}/dists/#{suite}/main/binary-#{arch}/Packages.gz",
                   File.join(download_cache, "Packages-#{suite}-#{arch}.gz"), refetch: true)
  return nil if index.nil?

  stanza = Zlib::GzipReader.open(index, &:read).split("\n\n").find do |st|
    st.start_with?("Package: libc6\n") || st.include?("\nPackage: libc6\n")
  end
  return nil if stanza.nil?

  { version: stanza[/^Version: (.+)$/, 1], url: "#{mirror}/#{stanza[/^Filename: (.+)$/, 1]}" }
end

# Debian version ordering is its own thing (epochs, tildes, +ubuntu suffixes),
# so let dpkg be the judge rather than guessing at it.
def newer?(version, than)
  system('dpkg', '--compare-versions', version, 'gt', than)
end

# @return [String?] Path of the libc unpacked out of the package, +nil+ if it holds none.
def unpack_libc(package, release, arch)
  deb = download(package[:url], File.join(download_cache, File.basename(package[:url])))
  return nil if deb.nil?

  dir = File.join(download_cache, "#{release}-#{arch}")
  unless File.directory?(dir)
    FileUtils.mkdir_p(dir)
    Dir.chdir(dir) do
      system("ar x #{deb.shellescape}", exception: true)
      system("tar -xf #{Dir.glob('data.tar*').first.shellescape}", exception: true)
    end
  end
  # libc.so.6 is the ELF itself on a recent glibc and a link to libc-<version>.so
  # on an older one; either way the real file is the one to read.
  Dir.glob(File.join(dir, '**', '{libc.so.6,libc-*.so}'))
     .find { |f| !File.symlink?(f) && File.file?(f) }
end

# @param [String] url
# @param [String] dest
# @param [Boolean] refetch Ask again even when +dest+ already holds an answer.
# @return [String?] +dest+, or +nil+ when the archive does not serve the URL.
def download(url, dest, refetch: false)
  return dest if !refetch && File.file?(dest) && File.size(dest).positive?

  ok = system("curl -fsSL -o #{dest.shellescape} #{url.shellescape}")
  return dest if ok

  FileUtils.rm_f(dest)
  nil
end

# Rewrite one build file from the libc itself.
# @param [String] libc Path of the libc to emulate.
# @param [String] source Where that libc came from, recorded in the build file.
# @return [String?] Basename of the build file written, +nil+ on failure.
def regenerate(libc, source)
  info = libc_info(libc, source)
  return puts('fail: cannot parse the libc') if info.nil? || info[:build_id].nil?

  version = info[:info].scan(/version ([\d.]+\d)/).flatten.first
  return puts('fail: no version string') if version.nil?

  gadgets = OneGadget.gadgets(file: libc, force_file: true, details: true, level: 100)
  return puts('fail: no gadgets found') if gadgets.empty?

  name = "libc-#{version}-#{info[:build_id]}"
  File.write(File.join(repo_root, 'lib', 'one_gadget', 'builds', "#{name}.rb"), template(info, gadgets))
  puts "#{gadgets.size} gadgets -> #{name}"
  name
end
