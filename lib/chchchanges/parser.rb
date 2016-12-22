require 'json'
require 'securerandom'
module Chchchanges
  class Parser
    attr_accessor :entries, :version, :type

    def initialize
      @entries = []
      @version = ""
      @type = ""
    end

    def call
      Dir.mkdir('.changelog_entries') unless Dir.exists?('.changelog_entries')
      parse_changelog
      write_to_files
    end

    private

    def get_version(line)
      line.match(/\[(.*?)\]/)[1]
    end

    def get_type(line)
      line.gsub('### ', '')
    end

    def get_description(line)
      match = line.match(/^.*[\]\-] /)[0]
      line.gsub(match, '')
    end

    def get_ticket(line)
      match = line.match(/\[(.*?)\]/)
      match ? match[1] : ""
    end

    def create_entry(line, version, type)
      description = get_description(line)
      ticket = get_ticket(line)
      info = {
        type: type,
        ticket: ticket,
        url: "",
        description: description,
        version: version,
        tags: []
      }.to_json
      @entries << info
    end

    def parse_changelog
      changelog_lines = File.readlines('CHANGELOG.md')
      changelog_lines.each_with_index do |line, index|
        line.strip!
        if line.start_with?('## [')
          @version = get_version(line)
        elsif line.start_with?('###')
          @type = get_type(line)
        elsif line.start_with?('-')
          create_entry(line, version, type)
        elsif line.empty?
        else
          puts "Warning: Unexpected input at line #{index + 1}"
        end
      end
    end

    def write_to_files
      @entries = @entries.uniq
      @entries.each do |entry|
        File.write(".changelog_entries/#{SecureRandom.hex}.json", entry)
      end
    end

  end
end
