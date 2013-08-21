module Tableau
  class ClassArray < Array

    def initialize
      super
    end

    # Returns an array of all the classes for the day
    def classes_for_day(day)
      days_classes = ClassArray.new
      self.each { |c| days_classes << c if c.day == day }
      days_classes.count > 0 ? days_classes : nil
    end

    # Returns the earliest class in the module
    def earliest_class
      earliest = self.first
      self.each { |c| earliest = c if c.time < earliest.time }
      earliest
    end

    # Returns the latest class in the module
    def latest_class
      latest = self.first
      self.each { |c| latest = c if c.time > latest.time }
      latest
    end

  end
end