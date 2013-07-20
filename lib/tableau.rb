module Tableau
	class << self

		def create(option = {})
			Tableau::Timetable.new(options)
		end

	end
end
