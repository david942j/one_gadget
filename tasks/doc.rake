# frozen_string_literal: true

require 'yard'

# What YARD is asked about: the library, minus the generated build files.
DOCUMENTED_FILES = Dir['lib/**/*.rb'] - Dir['lib/one_gadget/builds/*.rb']

# Everywhere a doc comment is written, which is more than YARD is pointed at.
COMMENTED_FILES = (DOCUMENTED_FILES + Dir['{spec,aletheia}/**/*.rb'] + Dir['tasks/**/*.rake'] +
                   Dir['{bin,aletheia/bin}/*']).sort

# A tag opens at the base indent; its description continues indented under it.
TAG_LINE = /\A#\s@\S/
CONTINUATION_LINE = /\A#\s\s/
SUMMARY_LINE = /\A#\s\S/

YARD::Rake::YardocTask.new(:doc) do |t|
  t.files = DOCUMENTED_FILES
  t.options = ['--fail-on-warning']
  t.stats_options = ['--list-undoc']
end

namespace :doc do
  desc 'Check that every doc comment describes the definition below it'
  task :orphans do
    strays = COMMENTED_FILES.flat_map do |path|
      orphaned_doc(path).map { |lineno, text| "#{path}:#{lineno}: #{text}" }
    end
    next if strays.empty?

    abort(<<~MESSAGE)
      A doc comment describes the definition below it, and these have run together with the one after
      them -- YARD gives the pair to whichever definition follows and the other's is silently lost:
      #{strays.join("\n")}
    MESSAGE
  end
end

# Where a comment block starts describing something else. Two blocks separated by
# nothing are one block to YARD, so the definition the first was written for ends
# up undocumented; the tell is a summary line following a tag, since a tag's own
# description continues indented.
# @param [String] path
# @return [Array<(Integer, String)>] The line number and text of each block's first stray summary.
def orphaned_doc(path)
  strays = []
  block = []
  File.readlines(path).each_with_index do |line, index|
    text = line.strip
    if text.start_with?('#')
      block << [index + 1, text]
    else
      strays << stray_summary(block) unless text.empty?
      block = []
    end
  end
  strays.compact
end

# The first line of +block+ that starts describing something the lines before it
# have already tagged.
# @param [Array<(Integer, String)>] block
# @return [(Integer, String), nil]
def stray_summary(block)
  tagged = false
  block.each do |lineno, text|
    next if CONTINUATION_LINE.match?(text)

    if TAG_LINE.match?(text) then tagged = true
    elsif tagged && SUMMARY_LINE.match?(text) then return [lineno, text]
    end
  end
  nil
end
