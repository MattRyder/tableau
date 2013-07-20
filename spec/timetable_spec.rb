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
      modules = ['CE00429-5', 'CE00758-5']
      @timetable = Tableau::Timetable.new.add_modules(modules)
    end

    it "should have 2 modules" do
      @timetable.modules.count.should eq(2)
    end

    it "should have 3 classes" do
      class_count = 0

      @timetable.modules.each do |mod|
        class_count += mod.classes.count
      end

      class_count.should eq(3)
    end

  end
end