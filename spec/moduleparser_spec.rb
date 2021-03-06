require 'spec_helper'

describe 'ModuleParser' do

  context "without file given" do

    before do
      @parser = Tableau::ModuleParser.new
    end

    it "should return a new Tableau ModuleParser object" do
      @parser.should be_an_instance_of Tableau::ModuleParser
    end

    it "should raise an error" do
      expect { @parser.parse }.to raise_error
    end
  end

  context "using Module ID CE00758-5" do

    before do
      @parser = Tableau::ModuleParser.new('CE00758-5')
      @module = @parser.parse
      @information = @parser.module_info
      @classes = @module.classes
    end

    it "should return 1+ class" do
      @classes.count >= 1
    end

    it "should have a class with the correct attributes" do
      @classes.first.tutor.should eq("Fleming G, Bradburn J")
      @classes.first.location.should eq("F005")
      @classes.first.type.should eq("2Prac")
      @classes.first.name.should eq("Film Technology 2")
    end

    it "should have a class at the correct time" do
      @classes.first.day.should eq(3)
      @classes.first.time.should == Time.new(2013, 1, 1, 11, 0, 0)
    end

    it "should return the correct module information" do
      @information[:name].should eq('Film Technology 2')
      @information[:code].should eq('CE00758-5')
    end
  end


  context "using Module ID CE00341-5" do

    before do
      @parser = Tableau::ModuleParser.new('CE00341-5')
      @information = @parser.module_info
      @module = @parser.parse
      @classes = @module.classes
    end

    it "should return 3+ classes" do
      @classes.count >= 3
    end

    it "should have a class with the correct attributes" do
      @classes.first.tutor.should eq("Sharp B, Roberts P")
      @classes.first.location.should eq("C346")
      @classes.first.type.should eq("Lec")
      @classes.first.name.should eq("AI Methods")
    end

    it "should have a class at the correct time" do
      @classes.first.day.should eq(1)
      @classes.first.time.should == Time.new(2013, 1, 1, 13, 0, 0)
    end

    it "should return the correct module information" do
      @information[:name].should eq('AI Methods')
      @information[:code].should eq('CE00341-5')
    end
  end

  context "using Module ID CE00871-6" do

    before do
      @parser = Tableau::ModuleParser.new('CE00871-6')
      @module = @parser.parse
      @information = @parser.module_info
      @classes = @module.classes
    end

    it "should return 3+ classes" do
      @classes.count >= 3
    end

    it "should have classes with the correct attributes" do
      @classes.each do |c|
        c.tutor.should eq("McCarren J, Hodgkiss D")
        c.name.should eq("Safety Critical and Embedded Systems")

        if c.type == 'Lec'
          c.location.should eq("C330")
        elsif c.type == 'Prac'
          c.location.should eq("K025 - Comp")
        end
      end
    end

    it "should return the correct module information" do
      @information[:name].should eq('Safety Critical and Embedded Systems')
      @information[:code].should eq('CE00871-6')
    end
  end

=begin SEMESTER 2 CLASS, TODO: REPLACE WITH SEM 1 CLASS

  # has two timetables with alternating classes
  context "using Module ID CE00748-3 (split week classes)" do

    before do
      @parser = Tableau::ModuleParser.new('CE00748-3')
      @module = @parser.parse
      @information = @parser.module_info
      @classes = @module.classes
    end

    it "should return 4+ class" do
      @classes.count >= 4
    end

    it "should have a class with the correct attributes" do
      @classes[1].tutor.should eq("Martyn A")
      @classes[1].location.should eq("S426")
      @classes[1].type.should eq("Tut")
      @classes[1].name.should eq("Principles of Materials")
    end

    it "should have the class valid for the right weeks on first timetable" do
      valid_weeks = [28, 29, 31, 32, 34, 35, 37, 38, 39]

      @classes[1].weeks.each do |week|
        valid_weeks.include?(week).should eq(true)
      end
    end

    it "should have a class at the correct time" do
      @classes.first.day.should eq(3)
      @classes.first.time.should == Time.new(2013, 1, 1, 9, 0, 0)
    end

    it "should have the class with the right weeks on the second timetable" do
      valid_weeks = [30, 33, 36]
      @classes[3].weeks.each { |week| valid_weeks.include?(week).should eq(true) }
    end

    it "should return the correct module information" do
      @information[:name].should eq('Principles of Materials')
      @information[:code].should eq('CE00748-3')
    end
  end

=end

end