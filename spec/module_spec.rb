require 'spec_helper'
require 'tableau/parser'
require 'tableau/module'
require 'tableau/class'

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

end