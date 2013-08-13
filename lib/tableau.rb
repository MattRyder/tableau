module Tableau
	class << self

		def create(option = {})
			Tableau::Timetable.new(options)
		end

    def module_info(module_code, semester)
      parser = Tableau::Timetable.new(module_code, semester)
      return parser.get_info
    end

	end
end
