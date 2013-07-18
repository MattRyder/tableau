require 'spec_helper'
require 'tableau/parser'
require 'tableau/class'

describe 'Parser' do

  context "without file given" do

    before do
      @parser = Tableau::Parser.new
    end

    it "should return a new Tableau Parser object" do
      @parser.should be_an_instance_of Tableau::Parser
    end

    it "should raise an error" do
      expect { @parser.parse_module }.to raise_error
    end
  end

  context "using Module ID CE00758-5" do

    before do
      @module = Tableau::Parser.new('CE00758-5', 2).parse_module
      @classes = @module.classes
    end

    it "should return 1 class" do
      @classes.count.should eq(1)
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
  end

  context "using Module ID CE00871-6" do

    before do
      @module = Tableau::Parser.new('CE00871-6', 2).parse_module
      @classes = @module.classes
    end

    it "should return 3 classes" do
      @classes.count.should eq(3)
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
  end

end