module Tableau
  class Timetable

    attr_accessor :id, :modules

    def initialize(options = {})
      @id = options[:id] || ''
      @modules = options[:modules] || Array.new

      add_modules(options[:module_codes]) if options[:module_codes]
    end

    def add_module(string_or_file)
      @module = Tableau::Parser.new(string_or_file).parse_module
      @modules << @module if @module
    end

    def add_modules(modules)
      modules.each{ |m| add_module(m) }
    end

    def remove_class(rem_class)
      mod_for_class = nil

      @modules.each do |m|
        if m.name == rem_class.name
          m.classes.delete(rem_class)
          break
        end
      end

    end

    def conflicts
      conflicts = Array.new

      (0..4).each do |day|
        days_classes = Array.new

        # Get classes for day
        @modules.each { |mod|
          c = mod.classes_for_day(day)
          c.each { |dc| days_classes << dc } if c
        }

        next if days_classes.count == 0

        # get the conflicts from the modules
        days_last = days_classes.count - 1

        for i in 0..days_last
          i_c = days_classes[i]
          time_range = i_c.time..(i_c.time + 60 * 60 * i_c.duration)

          for j in (i+1)..days_last
            if time_range.cover?(days_classes[j].time)
              conflicts << [days_classes[i], days_classes[j]]
            end
          end
        end
      end
      conflicts # return the conflicts
    end

    # HTML5 representation of the timetable
    def to_html

      days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri']
      time_header, rows = ''

      @time = Time.new(2013, 1, 1, 9, 0, 0)
      while @time <= Time.new(2013, 1, 1, 21, 0, 0)
        time_header += "<th>#{@time.strftime("%k:%M")}</th>"
        @time += 900
      end

      html =
      "<table #{id='@id' if @id}>" +
        "<tr>#{time_header}</tr>" +
        "<tr>#{rows}</tr>"
      "</table>"

    end

  end
end