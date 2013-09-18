module Tableau
  class Timetable

    attr_accessor :name, :modules

    # Create a new Timetable, with a Timetable Name and Student Set ID
    def initialize(timetable_name)
      @name = name || "Timetable"
      @modules = Array.new
    end

    # Pushes an existing module into the timetable
    def push_module(mod)
      @modules << mod
    end

    # Adds a Module to the Timetable via the Parser
    def add_module(module_code)
      @module = Tableau::ModuleParser.new(module_code).parse
      @modules << @module if @module
    end

    # Mass-adds an array of modules objects to the timetable
    def add_modules(modules)
      modules.each { |mod_code| add_module(mod_code) }
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
      classes = Tableau::ClassArray.new

      @modules.each do |mod|
        cfd = mod.classes_for_day(day)
        cfd.each { |cl| classes << cl } if cfd
      end

      classes.count > 0 ? classes : nil
    end

    # Returns the class at the given day & time
    def class_for_time(day, time)
      cfd = self.classes_for_day(day)
      cfd.each { |c| return c if c.time == time }
      nil
    end

    # Returns the module with given Module Code
    def module_for_name(module_name)
      modules.each { |m| return m if m.name }
      nil
    end

    # Return the Tableau::Module that matches a given code
    def module_for_code(mod_code)
      @modules.each { |m| return m if m.module_id == mod_code } if @modules
      nil
    end

    # Returns the earliest class on the timetable
    def earliest_class
      earliest_classes = Tableau::ClassArray.new
      @modules.each { |m| earliest_classes << m.earliest_class }

      earliest = earliest_classes.first
      earliest_classes.each { |c| earliest = c if c.time < earliest.time }
      earliest
    end

    # Returns the latest class on the timetable
    def latest_class
      latest_classes = Tableau::ClassArray.new
      @modules.each { |m| latest_classes << m.latest_class }

      latest = latest_classes.first
      latest_classes.each { |c| latest = c if c.time > latest.time }
      latest
    end

    # Returns an array of time conflicts found in the timetable
    def conflicts
      conflicts = Tableau::ClassArray.new

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