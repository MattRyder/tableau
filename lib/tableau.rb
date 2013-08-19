require 'json'
require 'tableau/timetable'
require 'tableau/parser'

module Tableau
	class << self

		def create(option = {})
			Tableau::Timetable.new(options)
		end

    def generate(module_codes)
      timetable = Tableau::Timetable.new(modules: module_codes)
      builder = Tableau::TableBuilder.new(timetable)
      builder.to_html
    end

    def module_info(module_code, semester)
      parser = Tableau::Parser.new(module_code, semester)
      parser.get_info
    end

	end
end
