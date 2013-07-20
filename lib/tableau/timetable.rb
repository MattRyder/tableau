module Tableau
  class Timetable

    attr_accessor :id, :modules

    def initialize(options = {})
      @id = options[:id] || ''
      @modules = options[:modules] || Array.new
    end

    def add_module(string_or_file)
      @module = Tableau::Parser.new(string_or_file).parse_module
      @modules << @module if @module
    end

    def add_modules(modules)
      modules.each{ |m| add_module(m) }
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