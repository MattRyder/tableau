require 'spec_helper'
require 'tableau/parser'

describe 'Timetable' do

  context "without modules" do

    before do
      @timetable = Tableau::Timetable.new("Test Timetable")
    end

    it "should return a new instance" do
      @timetable.should be_an_instance_of Tableau::Timetable
    end
  end

  context "with one module" do

    before do
      modules = ['CE00341-5']
      @timetable = Tableau::Timetable.new("Test Timetable", modules, 2)
      @firstclass = @timetable.modules.first.classes.first
    end

    it "should have 3 classes" do
      class_count = 0

      @timetable.modules.each do |mod|
        class_count += mod.classes.count
      end
    end

    it "should have a class with the correct attributes" do
      @firstclass.tutor.should eq("Sharp B")
      @firstclass.location.should eq("C346")
      @firstclass.type.should eq("Lec")
      @firstclass.name.should eq("AI Methods")
    end

    it "should have a class at the correct time" do
      @firstclass.day.should eq(2)
      @firstclass.time.should == Time.new(2013, 1, 1, 10, 0, 0)
    end
  end

  context "with conflicting modules" do

    before do
      modules = ['CE70046-4', 'CE70031-4']
      @timetable = Tableau::Timetable.new("Test Timetable", modules, 2)
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