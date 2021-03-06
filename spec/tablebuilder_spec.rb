require 'spec_helper'

describe 'TableBuilder' do

  before do
    modules = ['CE70091-4', 'CE00341-5', 'CE20035-4']
    timetable = Tableau::Timetable.new(id: 'My Timetable', module_codes: modules)
    @tablebuilder = Tableau::TableBuilder.new(timetable)
  end

  it "should return the html representation of the timetable" do
    @tablebuilder.to_html.should_not be_nil
  end

  it "should complete the HTML render in under 100ms" do
    Benchmark.realtime{ @tablebuilder.to_html }.should < 0.1
  end

end