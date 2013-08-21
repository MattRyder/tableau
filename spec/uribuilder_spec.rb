require 'spec_helper'

describe 'UriBuilder' do

  before do
    @uribuilder = Tableau::UriBuilder.new('CE00758-5', 2)
  end

  it 'should return an IO class of read data' do
  end


  it 'should return a correct URI' do
    @uribuilder.to_s.should eq("http://crwnmis3.staffs.ac.uk/Reporting/Individual;Modules;name;CE00758-5?&template=Module%20Individual%20SOC&weeks=26-42&days=1-5&periods=5-52&width=0&height=0")
  end
end