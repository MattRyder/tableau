module Tableau
  class Module

    attr_reader :module_id, :name, :classes

    def initialize(id, options = {})

      if validate_id(id); @module_id = id
      else raise "Module Code #{id} is invalid!"; end

      @name    = options[:name] || ''
      @classes = options[:classes] || Array.new
    end

    # Add a class to the module
    def add_class(new_class)
      @classes << new_class
    end

    # Returns an array of all the classes for the day
    def classes_for_day(day)
      days_classes = Array.new
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

    # Validates whether an ID follows the naming scheme
    def validate_id(id); /^(CE|ce)[0-9]{5}-[0-9]$/ =~ id; end

  end
end