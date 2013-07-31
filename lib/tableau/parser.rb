require 'open-uri'
require 'tableau/timetable'
require 'tableau/module'
require 'tableau/class'
require 'tableau/uribuilder'

module Tableau
  class Parser

    @@COURSE_DESCRIPTION_XPATH = '/html/body/table[1]//td//td/text()'

    @@FIRST_TIMETABLE_XPATH  = '/html/body/table[2]/tr'
    @@SECOND_TIMETABLE_XPATH = '/html/body/table[5]/tr'

    @@MODULE_ID_REGEX = /^CE[\d]{5}-[1-8]/
    @@WEEKS_REGEX = /[\d]{2}-[\d]{2}|[\d]{2}/

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
      raw_info = @raw_timetable.xpath(@@COURSE_DESCRIPTION_XPATH).to_html
      mod_id = @@MODULE_ID_REGEX.match(raw_info).to_s
      mod_name = raw_info.gsub(mod_id, '')

      mod = Tableau::Module.new(mod_id, name: mod_name)

      #Get the Classes for this Module, drop the time row
      tt_rows = @raw_timetable.xpath(@@FIRST_TIMETABLE_XPATH)

      table_classes = parse_table(mod_id, tt_rows)
      table_classes.each { |c| mod.classes << c }

      # is there a secondary timetable to rip?
      tt_second_table = @raw_timetable.xpath(@@SECOND_TIMETABLE_XPATH)

      if !tt_second_table.empty?
        table_classes = parse_table(mod_id, tt_second_table)
        table_classes.each { |c| mod.classes << c }
      end

      mod #return the module to the caller
    end

    def parse_table(module_id, table_rows)
      table_rows.delete(table_rows.first)
      classes = Array.new
      @day = 0

      table_rows.each do |row|
        @time = Time.new(2013, 1, 1, 9, 0, 0)

        # drop the 'Day' cell from the row
        row_items = row.xpath('td')
        row_items.delete(row_items.first)

        row_items.each do |cell|
          if cell.attribute('colspan')
            intervals = cell.attribute('colspan').value
            classes << make_class(module_id, cell)
          else intervals = 1
          end

          inc_time(intervals)
        end

        @day += 1
      end

      classes
    end

    # Generates the Lec/Tutorial item from the td element
    def make_class(module_id, class_element)

      begin
        tt_class = Tableau::Class.new(@day, @time)
        data = class_element.xpath('table/tr/td//text()')
        raise "Misformed cell for #{module_id}" if data.count < 4
      rescue Exception => e
        p "*** EXCEPTION: #{e.message}", "Data Parsed:", data
        return nil
      end

      if data[0].to_s.include?(module_id)
          tt_class.type = data[0].text().gsub("#{module_id}/", "")
      end

      tt_class.location  = data[1].text()
      tt_class.name      = data[2].text()
      tt_class.weeks     = make_class_weeks(data[3].text())
      tt_class.tutor     = data[4] ? data[4].text() : nil

      if intervals = class_element.attribute('colspan').value
        tt_class.intervals = intervals.to_i
      end

      tt_class
    end

    def make_class_weeks(week_data)
      week_span_regex  = /([\d]{2}-[\d]{2})/
      week_start_regex = /^[0-9]{2}/
      week_end_regex   = /[0-9]{2}$/
      week_single_regex = /[\d]{2}/

      class_weeks = Array.new

      week_data.scan(@@WEEKS_REGEX).each do |weekspan|

        # if it's a 28-39 week span
        if weekspan =~ week_span_regex
          start  = week_start_regex.match(weekspan)[0].to_i
          finish = week_end_regex.match(weekspan)[0].to_i

          while start <= finish
            class_weeks << start
            start += 1
          end

        # some single week (30, 31, 32 etc) support
        elsif weekspan =~ week_single_regex
          class_weeks << week_single_regex.match(weekspan)[0].to_i
        end
      end

      class_weeks
    end

    # Increments the @time by 15 minute intervals
    def inc_time(intervals)
      intervals.to_i.times { @time += 900 }
    end

  end
end