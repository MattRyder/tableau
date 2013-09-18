require 'spec_helper'

describe 'Baseparser' do

  before do
    @parser = Tableau::BaseParser.new
  end

  it "should return the correct xpaths" do
    @parser.xpath_for_table(1).should eq("/html/body/table[2]/tr")
    @parser.xpath_for_table(2).should eq("/html/body/table[5]/tr")
    @parser.xpath_for_table(3).should eq("/html/body/table[8]/tr")
    @parser.xpath_for_table(4).should eq("/html/body/table[11]/tr")
    @parser.xpath_for_table(5).should eq("/html/body/table[14]/tr")
  end

end

