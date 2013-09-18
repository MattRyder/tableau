module Tableau
  class Module

    attr_reader :module_id, :name, :classes

    def initialize(id, options = {})
      @module_id = id

      @name    = options[:name] || ''
      @classes = options[:classes] || Tableau::ClassArray.new
    end

    # Add a class to the module
    def add_class(new_class)
      @classes << new_class
    end

    # Returns an array of all the classes for the day
    def classes_for_day(day)
      days_classes = Tableau::ClassArray.new
      @classes.each { |c| days_classes << c if c.day == day }
      days_classes.count > 0 ? days_classes : nil
    end

    # Returns the earliest class in the module
    def earliest_class
      earliest = @classes.first
      @classes.each { |c| earliest = c if c.time < earliest.time }
      earliest
    end

    # Returns the latest class in the module
    def latest_class
      latest = @classes.first
      @classes.each { |c| latest = c if c.time > latest.time }
      latest
    end

  end
end