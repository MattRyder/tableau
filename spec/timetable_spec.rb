require 'spec_helper'
require 'tableau/parser'

describe 'Timetable' do

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