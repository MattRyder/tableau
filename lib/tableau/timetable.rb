module Tableau
  class Timetable

    attr_accessor :id, :modules

    def defaults
      def_opts = { modules: Array.new, id: nil }
    end

    def initialize(options = {})
      defaults.merge!(options)
    end

    def add_modules(modules)
      modules.each{_|m| add_module(m) }
    end


    def add_module(string_or_file)
      @module = Tableau::Parser.new(string_or_file).parse_module
      @modules << @module if @module
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
      "<table #{id='@name' if @name}>" +
        "<tr>#{time_header}</tr>" +
        "<tr>#{rows}</tr>"
      "</table>"

    end

  end
end