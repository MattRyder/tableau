require 'spec_helper'
require 'benchmark'

require 'tableau/tablebuilder'
require 'tableau/timetable'
require 'tableau/parser'

describe 'TableBuilder' do

  before do
    modules = [['CE70091-4', 2], ['CE00341-5', 2], ['CE20035-4', 2]]
    timetable = Tableau::Timetable.new(id: 'r004581a', module_codes: modules)
    @tablebuilder = Tableau::TableBuilder.new(timetable)
  end

  it "should return the html representation of the timetable" do
    @tablebuilder.to_html.should_not be_nil
  end

  it "should complete the HTML render in under 10ms" do
    Benchmark.realtime{ @tablebuilder.to_html }.should < 0.01
  end

end