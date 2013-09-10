require 'open-uri'
require 'nokogiri'
require 'tableau/baseparser'
require 'tableau/timetable'
require 'tableau/module'
require 'tableau/class'
require 'tableau/uribuilder'
require 'tableau/classarray'

module Tableau
  class ModuleParser < Tableau::BaseParser

    @@MODULE_ID_REGEX = /^CE[\d]{5}-[1-8]/
    attr_reader :raw_timetable

    # Create a new ModuleParser, with an optional module code
    def initialize(module_code = nil)
      begin
        timetable_response = Tableau::UriBuilder.new(module_code, module_lookup: true).read
        @raw_timetable = Nokogiri::HTML(timetable_response) if timetable_response
      rescue OpenURI::HTTPError
        return nil
      end
    end

    def module_info
      mod, types = parse, Set.new
      mod.classes.each { |c| types.add?(c.type) }

      return { name: mod.name, code: mod.module_id, types: types }
    end

    def parse
      raise "No module timetable loaded!" unless @raw_timetable

      #Get the ID and Name from the first <table>
      raw_info    = @raw_timetable.xpath(@@COURSE_DESCRIPTION_XPATH).to_html
      module_id   = @@MODULE_ID_REGEX.match(raw_info).to_s
      module_name = raw_info.gsub(module_id, '')

      mod = Tableau::Module.new(module_id, name: module_name)
      table_count = 1
      table_data = @raw_timetable.xpath(xpath_for_table(table_count))

      # Iterate through each timetable until xpath returns no more timetable tables
      while !table_data.empty?
        tables_classes = parse_table(module_id, table_data)
        tables_classes.each { |c| mod.classes << c }
        table_count += 1
      end

      mod #return the module to the caller
    end

    # Parse the module table for any classes
    def parse_table(module_id, table_rows)
      classes = Tableau::ClassArray.new
      @day = 0

      # delete the time header row
      table_rows.delete(table_rows.first)

      table_rows.each do |row|
        @time = Time.new(2013, 1, 1, 9, 0, 0)

        # drop the 'Day' cell from the row
        row_items = row.xpath('td')
        row_items.delete(row_items.first)

        row_items.each do |cell|
          if cell.attribute('colspan')
            intervals = cell.attribute('colspan').value
            classes << create_class(module_id, cell)
          else intervals = 1
          end

          inc_time(intervals)
        end

        @day += 1
      end

      classes
    end

  end
end