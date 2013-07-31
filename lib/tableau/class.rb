module Tableau
  class Class

    attr_accessor :type, :location, :name, :tutor,
                  :day, :time, :intervals, :weeks

    def defaults
      def_opts = {
        type: '',
        location: '',
        name: '',
        tutor: '',
        intervals: 4,
        day: 0,
        time: Time.new
      }
    end

    def initialize(day, time, options = {})
      @day = day
      @time = time
      @weeks = Array.new
      defaults.merge!(options)
    end

    # Duration of the class in hours
    def duration
      @intervals / 4
    end

  end
end