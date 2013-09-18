require 'tableau/baseparser'

module Tableau
  class TimetableParser < Tableau::BaseParser

    @@TIMETABLE_CODE_REGEX = /^[A-Za-z0-9\(\)]+/

    # Create a new TimetableParser, with a Student Set ID (aka Core Timetable)
    def initialize(student_set_id = nil)
      begin
        timetable_response = Tableau::UriBuilder.new(student_set_id).read
        @raw_timetable = Nokogiri::HTML(timetable_response) if timetable_response
      rescue OpenURI::HTTPError
        return nil
      end
    end

    # Get a summary of information about this timetable
    def timetable_info
    end

    # Parse the Timetable for all Modules within
    # Returns: A Tableau::Timetable
    def parse
      raise "No Timetable loaded!" unless @raw_timetable

      table_info = @@TIMETABLE_CODE_REGEX.match(get_info(@raw_timetable))
      timetable = Tableau::Timetable.new(table_info)

      table_count = 1
      table_data = @raw_timetable.xpath(xpath_for_table(table_count))

      while !table_data.empty?
        table_classes = parse_table(table_data)
        sort_classes(timetable, table_classes)
        table_data = @raw_timetable.xpath(xpath_for_table(table_count += 1))
      end
      timetable
    end

    # Sort all the parsed classes into modules
    def sort_classes(timetable, classes)
      classes.each do |c|
        if !(cmodule = timetable.module_for_code(c.code))
          cmodule = Tableau::Module.new(c.code)
          timetable.push_module(cmodule)
        end

        cmodule.add_class(c)
      end
    end

  end
end