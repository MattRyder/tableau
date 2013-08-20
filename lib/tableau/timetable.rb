module Tableau
  class Timetable

    attr_accessor :name, :modules

    def initialize(name, module_codes = {}, semester = 1)
      @name = name || ''
      @modules = Array.new

      add_modules(module_codes, semester) if module_codes
    end

    # Adds a Module to the Timetable via the Parser
    def add_module(module_code, semester)
      @module = Tableau::Parser.new(module_code, semester).parse_module
      @modules << @module if @module
    end

    # Mass-adds an array of modules objects to the timetable
    def add_modules(modules, semester)
      modules.each { |mod| add_module(mod, semester) }
    end

    # Removes a class from the timetable
    def remove_class(rem_class)
      @modules.each do |m|
        if m.name == rem_class.name
          m.classes.delete(rem_class)
          break
        end
      end
    end

    # Returns an array of the given day's classes
    def classes_for_day(day)
      classes = Array.new

      @modules.each do |mod|
        cfd = mod.classes_for_day(day)
        cfd.each { |cl| classes << cl } if cfd
      end

      classes.count > 0 ? classes : nil
    end

    # Returns the class at the given day & time or nil if nothing
    def class_for_time(day, time)
      cfd = self.classes_for_day(day)
      cfd.each { |c| return c if c.time == time }
      nil
    end

    # Returns an array of time conflicts found in the timetable
    def conflicts
      conflicts = Array.new

      (0..4).each do |day|
        days_classes = self.classes_for_day(day)
        next if !days_classes || days_classes.count == 0

        # get the last element index
        last = days_classes.count - 1

        for i in 0..last
          i_c = days_classes[i]
          time_range = i_c.time..(i_c.time + 3600 * i_c.duration)

          for j in (i+1)..last
            if time_range.cover?(days_classes[j].time)
              conflicts << [days_classes[i], days_classes[j]]
            end
          end
        end
      end
      conflicts # return the conflicts
    end
  end
end