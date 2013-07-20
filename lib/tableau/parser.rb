require 'open-uri'
require 'tableau/timetable'
require 'tableau/module'
require 'tableau/uribuilder'

module Tableau
  class Parser

    @@COURSE_INFO_XPATH = '/html/body/table[1]//td//td/text()'
    @@CLASS_INFO_XPATH  = '/html/body/table[2]/tr'
    @@MODULE_ID_REGEX = /^CE[0-9]{5}-[0-9]/

    attr_reader :raw_timetable

    def initialize(string_or_file = nil, semester = 1)

      if string_or_file =~ @@MODULE_ID_REGEX
        string_or_file = Tableau::UriBuilder.new(string_or_file, semester).read
      end

      @raw_timetable = Nokogiri::HTML(string_or_file)
      @time = Time.new(2013, 1, 1, 9, 0, 0)
      @day = 0
    end

    def parse_module
      raise "No timetable loaded!" unless @raw_timetable

      #Get the ID and Name from the first <table>
      raw_info = @raw_timetable.xpath(@@COURSE_INFO_XPATH).to_html
      mod_id = @@MODULE_ID_REGEX.match(raw_info).to_s
      mod_name = raw_info.gsub(mod_id, '')

      mod = Tableau::Module.new(mod_id, name: mod_name)

      #Get the Classes for this Module, drop the time row
      tt_rows = @raw_timetable.xpath(@@CLASS_INFO_XPATH)
      tt_rows.delete(tt_rows.first)

      # Iterate through each day, get the classes
      tt_rows.each do |row|
        @time = Time.new(2013, 1, 1, 9, 0, 0)

        # Drop the day cell from the row
        row_items = row.xpath('td')
        row_items.delete(row_items.first)

        # Iterate through the day, collect classes
        row_items.each do |cell|

          # If it has colspan attr, it's a class cell
          if cell.attribute('colspan')
            intervals = cell.attribute('colspan').value
            mod.add_class(make_class(mod_id, cell))
          else intervals = 1
          end

          # Finished, increment time
          inc_time(intervals)
        end

        @day += 1


      end

      mod #return the module to the caller
    end

    # Generates the Lec/Tutorial item from the td element
    def make_class(module_id, class_element)

      begin
        tt_class = Tableau::Class.new(@day, @time)
        data = class_element.xpath('table/tr/td//text()')
        raise "Misformed cell for #{module_id}" if data.count != 5
      rescue Exception => e
        p "*** EXCEPTION: #{e.message}"
        p 'Data Parsed:', data
        return nil
      end

      if data[0].to_s.include?(module_id)
          tt_class.type = data[0].text().gsub("#{module_id}/", "")
      end

      tt_class.location  = data[1].text()
      tt_class.name      = data[2].text()
      tt_class.tutor     = data[4].text()

      if intervals = class_element.attribute('colspan').value
        tt_class.intervals = intervals.to_i
      end

      tt_class
    end

    # Increments the @time by 15 minute intervals
    def inc_time(intervals)
      intervals.to_i.times do
        @time += 900
      end
    end

  end
end