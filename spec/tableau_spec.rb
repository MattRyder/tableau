require 'spec_helper'

describe "Tableau" do

  before do
    @info = Tableau.module_info('CE00758-5', 2)

    module_list = ['CE00758-5', 'CE00341-5']
    @data = Tableau.generate("My Test Timetable", module_list, 2)
  end

  it "should return the correct module info" do
    @info[:code].should eq('CE00758-5')
    @info[:name].should eq('Film Technology 2')
  end

  it "should return the HTML representation" do
    @data.should_not eq(nil)
  end

end