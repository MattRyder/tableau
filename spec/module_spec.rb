require 'spec_helper'
require 'tableau/parser'
require 'tableau/module'
require 'tableau/class'


describe 'Module' do

  context "using a source timetable" do

    before do
      @file = open("#{fixture_path}/files/sesi-markup.html")
      @parser = Tableau::Parser.new(@file)
      @module = @parser.parse_module
    end

    it "should return a new instance" do
      @module.should be_an_instance_of Tableau::Module
    end

    it "should return the correct Course ID" do
      @module.module_id.should == 'CE01096-5'
    end

    it "should return the correct amount of classes" do
      @module.classes.count.should == 3
    end
  end

  context "when manually building a timetable" do

    before do
      @module = Tableau::Module.new(
        'CE12345-6',
        name: 'Testing Rails Applications with RSpec'
      )
    end

    it "should reject an invalid Course ID" do
      expect { Tableau::Module.new('INVALID-123') }.to raise_error
    end

    it "should return the correct Module ID" do
      @module.module_id.should == 'CE12345-6'
    end

    it "should return the correct Module Name" do
      @module.name.should == 'Testing Rails Applications with RSpec'
    end

  end

end