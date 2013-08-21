require 'spec_helper'

describe "ClassArray" do

  before do
    mod = Tableau::Parser.new('CE61006-4', 1).parse_module
    @array = Tableau::ClassArray.new
    @array.concat(mod.classes)
  end

  it "should have the right class type" do
    @array.class.should eq(Tableau::ClassArray)
  end

  it "should have classes associated" do
    @array.count.should_not eq(0)
  end

  it "should have an earliest class of 9AM" do
    earliest_class = @array.earliest_class
    earliest_class.time.should eq(Time.new(2013, 1, 1, 9, 0, 0))
  end

  it "should have a latest class of 5PM" do
    latest_class = @array.latest_class
    latest_class.time.should eq(Time.new(2013, 1, 1, 17, 0, 0))
  end

end