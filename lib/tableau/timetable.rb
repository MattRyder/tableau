module Tableau
  class Timetable

    attr_accessor :id, :modules

    def initialize(options = {})
      @id = options[:id] || ''
      @modules = options[:modules] || Array.new

      add_modules(options[:module_codes]) if options[:module_codes]
    end

    def classes_for_day(day)
      classes = Array.new

      @modules.each do |mod|
        cfd = mod.classes_for_day(day)
        cfd.each { |cl| classes << cl } if cfd
      end

      classes.count > 0 ? classes : nil
    end

    def class_for_time(day, time)
      cfd = self.classes_for_day(day)
      cfd.each_with_index do |c|
        return c if c.time == time
      end
      nil
    end

    def add_module(string_or_file, semester)
      @module = Tableau::Parser.new(string_or_file, semester).parse_module
      @modules << @module if @module
    end

    def add_modules(modules)
      modules.each{ |m, s| add_module(m, s) }
    end

    def remove_class(rem_class)
      @modules.each do |m|
        if m.name == rem_class.name
          m.classes.delete(rem_class)
          break
        end
      end
    end

    def conflicts
      conflicts = Array.new

      (0..4).each do |day|
        days_classes = self.classes_for_day(day)
        next if !days_classes || days_classes.count == 0

        # get the conflicts from the modules
        days_last = days_classes.count - 1

        for i in 0..days_last
          i_c = days_classes[i]
          time_range = i_c.time..(i_c.time + 60 * 60 * i_c.duration)

          for j in (i+1)..days_last
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