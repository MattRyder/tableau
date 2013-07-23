module Tableau
  class Module

    attr_reader :module_id, :name, :classes

    def initialize(id, options = {})

      if validate_id(id)
        @module_id = id
      else
        raise "Module Code #{id} is invalid!"
      end

      @name    = options[:name] || ''
      @classes = options[:classes] || Array.new
    end

    def add_class(new_class)
      @classes << new_class
    end

    def classes_for_day(day)
      days_classes = Array.new

      @classes.each do |c|
        days_classes << c if c.day == day
      end

      days_classes.count > 0 ? days_classes : nil
    end

    def validate_id(id)
      /^CE[0-9]{5}-[0-9]$/ =~ id
    end

  end
end