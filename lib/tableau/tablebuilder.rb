module Tableau
  class TableBuilder

    def css_defaults
      css_defaults = {
        body_color:      '#F4F5F6',
        border_color:    'rgba(0, 0, 0, 0.25)',
        class_color:     '#a9b1b9',
        header_bg_color: '#CFD3D7',
        header_fg_color: '#25292D',
        empty_color:     '#EBEDEE'
      }
    end

    def initialize(timetable, css_options = {})
      @timetable = timetable
      @css = css_defaults.merge(css_options)
    end

    def build_css
    %Q{
    body {
      background-color: #{@css[:body_color]};
    }

    table {
      border-collapse: collapse;
      border: 1px solid #{@css[:border_color]};
    }

    #time {
      background-color: #{@css[:header_bg_color]};
      color: #{@css[:header_fg_color]};
    }

    #time > th {
      font-weight: lighter;
    }

    .dh {
      background-color: #{@css[:header_bg_color]};
      color: #{@css[:header_fg_color]};
    }

    td {
      background-color: #{@css[:empty_color]};
      border: 1px solid #{@css[:border_color]};
      padding: 5px;
    }

    .class_item {
      background-color: #{@css[:class_color]};
    }
    }
    end

    def day_row(day, end_time = nil)
      time = Time.new(2013, 1, 1, 9, 0 , 0)
      end_time ||= Time.new(2013, 1, 1, 21, 0, 0)

      day_row = %Q{<td class="dh">#{days[day]}</td>}
      classes = @timetable.classes_for_day(day)

      if !classes || classes.count == 0
        while time < end_time
          day_row += "<td></td>"
          time += 900 # 15 mins in seconds
        end
      else
        while time < end_time
          class_at_time = @timetable.class_for_time(day, time)
          if class_at_time
            day_row += make_class(class_at_time)
            time += (900 * class_for_time.intervals)
          else
            day_row += "<td></td>"
            time += 900 # 15 mins in seconds
          end
        end
      end
      day_row
    end

    # Create the HTML for a class item on the table
    def make_class(klass)
      %Q{
        <td class="class_item" colspan="#{klass.intervals}">
          <p>#{klass.name} - #{klass.location}</p>
          <p>#{klass.type}</p>
        </td>}
    end




    # HTML5 representation of the timetable
    def to_html
      days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri']
      time_header, rows = '<th></th>', Array.new
      end_time = Time.new(2013, 1, 1, 21, 0, 0)

      # make the time row
      @time = Time.new(2013, 1, 1, 9, 0, 0)
      while @time < end_time
        time_header += "<th>#{@time.strftime("%-k:%M")}</th>"
        @time += 900
      end

      #make each day row
      (0..4).each do |day|
        day_row = "<td class=\"dh\">#{days[day]}</td>"
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
              day_row += %Q{
                <td class="class_item" colspan="#{class_at_time.intervals}">
                  #{class_at_time.name}
                </td>}
              time += (60 * 15 * class_at_time.intervals)
            else
              day_row += "<td></td>"
              time += (60 * 15)
            end
          end
        end
        rows << day_row
      end # End the day


      rows_str, id_str = '', "id=\"#{@timetable.name}\""
      rows.each{ |r| rows_str += "<tr class=\"day\">\n#{r}\n</tr>\n" }

      %Q{
        <!DOCTYPE html>
        <html>
        <head>
          <title>#{@timetable.name || 'Timetable' } - Timetablr.co</title>
          <style>#{build_css}</style>
        </head>
        <body>
          <h3>#{@timetable.name}</h3>
          <table #{id_str if @timetable.name}>
            <tr id="time">#{time_header}</tr>
            #{rows_str}
          </table>
        </body>
        </html>
      }
    end

  end
end