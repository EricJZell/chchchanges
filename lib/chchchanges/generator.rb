require 'json'
module Chchchanges
  class Generator
    attr_accessor :changelog_hash, :changelog

    def initialize
      @changelog_hash = {}
      @changelog = "# Change Log\n"
    end

    def call
      read_changelog_entry_files
      write_to_changelog_file
    end

    private

    def read_changelog_entry_files
      Dir.foreach('.changelog_entries') do |json_file|
        next if json_file == '.' or json_file == '..'
        entry = File.read(".changelog_entries/#{json_file}")
        entry_hash = JSON.parse(entry)
        version = entry_hash["version"]
        type = entry_hash["type"]
        description = entry_hash["description"]
        ticket = entry_hash["ticket"]
        @changelog_hash[version] = {} unless changelog_hash[version]
        @changelog_hash[version][type] = [] unless changelog_hash[version][type]
        @changelog_hash[version][type] << "- [#{ticket}] #{description}\n"
      end
    end

    def write_to_changelog_file
      versions = @changelog_hash.keys.sort_by{|v| Gem::Version.new(v)}.reverse
      versions.each do |version|
        change_types = changelog_hash[version]
        @changelog << "\n## [#{version}]\n"
        change_types.sort.each do |type, changes|
          @changelog << "### #{type}\n"
          changes.sort.each do |change|
            @changelog << change
          end
        end
      end
      File.write('9CHANGELOG.md', @changelog)
    end
  end
end
