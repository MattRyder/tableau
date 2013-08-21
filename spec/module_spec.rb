require 'spec_helper'

describe 'Module' do

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
      @module.module_id.should eq('CE12345-6')
    end

    it "should return the correct Module Name" do
      @module.name.should eq('Testing Rails Applications with RSpec')
    end
  end

  context "when accessing data attributes" do
    before do
      @module = Tableau::Parser.new('CE00952-5', 2).parse_module
    end

    it "should have an earliest class of 9AM" do
      @module.earliest_class.time.should eq(Time.new(2013, 1, 1, 9, 0, 0))
    end

    it "should have a latest class of 4PM" do
      @module.latest_class.time.should eq(Time.new(2013, 1, 1, 16, 0, 0))
    end
  end


end