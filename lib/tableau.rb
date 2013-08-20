require 'json'
require 'tableau/timetable'
require 'tableau/parser'
require 'tableau/tablebuilder'

module Tableau
	class << self

    def generate(table_id, module_codes, semester)
      timetable = Tableau::Timetable.new(table_id, module_codes, semester)
      builder = Tableau::TableBuilder.new(timetable)
      builder.to_html
    end

    def module_info(module_code, semester)
      parser = Tableau::Parser.new(module_code, semester)
      parser.get_info
    end

	end
end
