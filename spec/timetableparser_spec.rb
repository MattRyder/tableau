require 'spec_helper'

describe 'TimetableParser' do

  context "without file given" do

    before do
      @parser = Tableau::TimetableParser.new
    end

    it "should return a new Tableau TimetableParser object" do
      @parser.should be_an_instance_of Tableau::TimetableParser
    end

    it "should raise an error" do
      expect { @parser.parse }.to raise_error
    end
  end

  context "using Level 3 CS timetable" do

    before do
      @parser = Tableau::TimetableParser.new('l3cs')
      @timetable = @parser.parse
    end

    it "should return 1+ module" do
      @timetable.modules.count >= 1
    end

  end


  context "using Electrical Engineering - Level 4" do

    before do
      @parser = Tableau::TimetableParser.new('BH1EL')
      @timetable = @parser.parse
    end

    it "should return 1+ module" do
      @timetable.modules.count >= 1
    end

  end
end