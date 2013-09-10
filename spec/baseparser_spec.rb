require 'spec_helper'

describe 'Baseparser' do

  before do
    @parser = Tableau::BaseParser.new
  end

  it "should return the correct xpaths" do
    @parser.xpath_for_table(1).should eq("/html/body/table[1]/tr")
    @parser.xpath_for_table(2).should eq("/html/body/table[3]/tr")
    @parser.xpath_for_table(3).should eq("/html/body/table[5]/tr")
    @parser.xpath_for_table(4).should eq("/html/body/table[7]/tr")
    @parser.xpath_for_table(5).should eq("/html/body/table[9]/tr")
  end

end

