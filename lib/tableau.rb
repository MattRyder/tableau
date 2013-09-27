require 'json'
require 'tableau/timetable'
require 'tableau/moduleparser'
require 'tableau/timetableparser'
require 'tableau/tablebuilder'

module Tableau
	class << self

    # Generates the HTML version of a timetable of modules
    def generate(table_id, module_codes)
      timetable = Tableau::Timetable.new(table_id, module_codes)
      builder = Tableau::TableBuilder.new(timetable)
      builder.to_html
    end

    # Return the Name, Code and Types (2Prac / PracA / PracB etc) from the timetable
    def module_info(module_code)
      Tableau::ModuleParser.new(module_code).module_info
    end

    # Returns a Timetable object with the core timetable parsed
    def core_timetable(course_code)
      Tableau::TimetableParser.new(course_code).parse
    end

	end
end
