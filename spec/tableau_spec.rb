require 'spec_helper'

describe "Tableau" do

  before do
    @info = Tableau.module_info('CE00758-5')
    #@rts_info = Tableau.module_info('CE00870-6')

    module_list = ['CE00758-5', 'CE00341-5']
    @data = Tableau.generate("My Test Timetable", module_list)
  end

  it "should return the correct module info" do
    @info[:code].should eq('CE00758-5')
    @info[:name].should eq('Film Technology 2')
  end

=begin SEMESTER 2 TEST - TODO: REPLACE WITH SEM 1 TEST CASE
  it "should return the correct amount of class types" do
    @rts_info[:code].should eq('CE00870-6')
    @rts_info[:name].should eq('Real Time Systems')
    @rts_info[:types].count.should eq(3)

    types = @rts_info[:types]
    types.include?('Lec').should eq(true)
    types.include?('PracA').should eq(true)
    types.include?('PracB').should eq(true)
  end

  it "should return the HTML representation" do
    @data.should_not eq(nil)
  end
=end

end