module Tableau
  class TableBuilder

    def initialize(timetable)
      @timetable = timetable
    end

    def to_json
    end

    # HTML5 representation of the timetable
    def to_html

      days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri']
      time_header, rows = '<th></th>', Array.new
      end_time = Time.new(2013, 1, 1, 21, 0, 0)

      # make the time row
      @time = Time.new(2013, 1, 1, 9, 0, 0)
      while @time <= end_time
        time_header += "<th>#{@time.strftime("%-k:%M")}</th>"
        @time += 900
      end

      #make each day row
      (0..4).each do |day|
        day_row = "<td>#{days[day]}</td>"
        time = Time.new(2013, 1, 1, 9, 0 , 0)
        classes = @timetable.classes_for_day(day)

        if !classes || classes.count == 0
          while time < end_time
            day_row += "<td></td>"
            time += (60 * 15) #15 mins in seconds
          end
        else
          while time < end_time
            class_at_time = @timetable.class_for_time(day, time)
            if class_at_time
              day_row += "<td class=\"class_item\" colspan=\"#{class_at_time.intervals}\">" +
                    "#{class_at_time.name}" +
                    "</td>"
              time += (60 * 15 * class_at_time.intervals)
            else
              day_row += "<td></td>"
              time += (60 * 15)
            end
          end
        end
        rows << day_row
      end # End the day


      rows_str, id_str = '', "id=\"#{@timetable.id}\""
      rows.each{ |r| rows_str += "<tr class=\"day\">\n#{r}\n</tr>\n" }

      "<table #{id_str if @timetable.id}>\n" +
        "<tr id=\"time\">\n#{time_header}</tr>\n" +
        rows_str +
      "</table>"
    end

  end
end