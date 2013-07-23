require 'spec_helper'
require 'tableau/parser'

describe 'Timetable' do

  context "without modules" do

    before do
      @timetable = Tableau::Timetable.new
    end

    it "should return a new instance" do
      @timetable.should be_an_instance_of Tableau::Timetable
    end

    it "should return the timetable as HTML" do
      @timetable.to_html.should_not == nil
    end
  end

  context "with conflicting modules" do

    before do
      modules = ['CE70046-4', 'CE70031-4']
      @timetable = Tableau::Timetable.new(module_codes: modules)
      @conflicts = @timetable.conflicts
    end

    it "should have 2 modules" do
      @timetable.modules.count.should eq(2)
    end

    it "should have 2 classes" do
      class_count = 0

      @timetable.modules.each do |mod|
        class_count += mod.classes.count
      end

      class_count.should eq(2)
    end

    it "should return one conflict" do
      @conflicts.count.should eq(1)
    end

    it "should resolve conflicts" do
      @timetable.remove_class(@conflicts[0].first)
      @timetable.conflicts.count.should eq(0)
    end
  end
end