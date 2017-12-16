require 'readline'
require 'json'
require 'securerandom'
module Chchchanges
  class Entry
    attr_reader :entry_file_dir

    def initialize(entry_file_dir='.changelog_entries')
      @entry_file_dir = entry_file_dir
    end

    def call
      Dir.mkdir(@entry_file_dir) unless Dir.exists?(@entry_file_dir)
      write_to_file
    end

    private

    def get_version
      puts "What is the targeted release version for this change? (example '15.5.11')"
      user_input = get_user_input
      if user_input.match(/^(\d+\.)+\d+$/)
        return user_input
      else
        handle_unexpected_input(user_input, "Invalid version number")
        get_version
      end
    end

    def get_type
      change_types_hash = {
        1 => "Added", 2 => "Changed", 3 => "Fixed", 4 => "Deprecated",
        5 => "Removed", 6 => "Security", 7 => "Unspecified"
      }
      puts "What type of change is this?\n"
      change_types_hash.each do |number, change_type|
        puts "#{number} - #{change_type}\n"
      end
      user_input = get_user_input
      if change_types_hash.keys.include?(user_input.to_i)
        return change_types_hash[user_input.to_i]
      else
        handle_unexpected_input(user_input, "Invalid change type selection")
        get_type
      end
    end

    def get_tags
      puts "Please enter any tags, comma separated. (Optional)"
      tags = get_user_input.split(',')
      tags.map! { |tag| tag.strip}
    end

    def get_ticket
      puts "Please enter Ticket # (Optional):"
      @ticket = get_user_input
    end

    def get_description
      puts "Please enter a description for this change (at least 5 characters):"
      description = get_user_input
      if description.match(/^.{5}/)
        return description
      else
        handle_unexpected_input(description, "Invalid Description")
        get_description
      end
    end

    def handle_unexpected_input(input, message)
      if input.downcase == 'q'
        puts "Goodbye!"
        exit
      else
        puts message
      end
    end

    def write_to_file
      version = get_version
      info = {
        type: get_type,
        ticket: get_ticket,
        url: "",
        description: get_description,
        version: version,
        tags: get_tags
      }.to_json
      File.write("#{@entry_file_dir}/#{Time.now.strftime("%Y%m%d%H%M%S%L")}_ticket#{@ticket}.json", info)
    end

    def get_user_input
      Readline.readline('', true).strip
    end

  end

end
