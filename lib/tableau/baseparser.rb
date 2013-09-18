require 'tableau/timetable'
require 'tableau/module'
require 'tableau/class'
require 'tableau/uribuilder'
require 'tableau/classarray'

module Tableau
  class BaseParser

    @@COURSE_DESCRIPTION_XPATH = '/html/body/table[1]//td//td/text()'
    @@WEEKS_REGEX = /^([\d]{2}-[\d]{2})|^([\d]{2})/

    # Create a new instance of the BaseParser, with an ID to lookup
    def initalize(lookup_id)
      @time, @day = Time.new(2013, 1, 1, 9, 0, 0), 0
      @lookup_id  = lookup_id
    end

    # Parse the module table for any classes
    def parse_table(table_rows)
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
            classes << create_class(cell)
          else intervals = 1
          end

          inc_time(intervals)
        end

        @day += 1
      end

      classes
    end

    # Create a Class from the given data element
    def create_class(class_element)
      begin
        tt_class = Tableau::Class.new(@day, @time)
        data = class_element.xpath('table/tr/td//text()')
        raise "Misformed cell for #{module_id}" if data.count < 4
      rescue Exception => e
        p "EXCEPTION: #{e.message}", "Data Parsed:", data
        return nil
      end

      # If the weeks are in the 2nd index, it's a core timetable
      if @@WEEKS_REGEX.match(data[1].text())
        tt_class.code = data[0].text().match(/^[A-Za-z0-9\-]+/).to_s
        tt_class.type = data[0].text().gsub(tt_class.code, '').gsub('/', '')

        tt_class.weeks    = create_class_weeks(data[1].text())
        tt_class.location = data[2].text()
        tt_class.name     = data[3].text()
      else # this is a module timetable, laid out differently
        if data[0].to_s != ""
          tt_class.code = data[0].text().match(/^[A-Za-z0-9\-]+/).to_s
          tt_class.type = data[0].text().gsub(tt_class.code, '').gsub('/', '')
        end

        tt_class.location  = data[1].text()
        tt_class.name      = data[2].text()
        tt_class.weeks     = create_class_weeks(data[3].text())
      end

      # Same attribute on both timetables, DRY'd here
      tt_class.tutor = data[4] ? data[4].text() : nil

      if intervals = class_element.attribute('colspan').value
        tt_class.intervals = intervals.to_i
      end

      tt_class
    end

    # Create the week range array for the given week string
    def create_class_weeks(week_data)
      week_span_regex   = /([\d]{2}-[\d]{2})/
      week_start_regex  = /^[0-9]{2}/
      week_end_regex    = /[0-9]{2}$/
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

    # Get the ID string in the first <table> element (usually <:code> - <:name>)
    def get_info(timetable_data)
      timetable_data.xpath(@@COURSE_DESCRIPTION_XPATH).to_html
    end

    # Returns the XPath for the nth table
    def xpath_for_table(table_count)
      "/html/body/table[#{3 * table_count - 1}]/tr"
    end

  end
end