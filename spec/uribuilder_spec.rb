require 'spec_helper'

describe 'UriBuilder' do

  context 'looking up a timetable set' do

    before do
      @uribuilder = Tableau::UriBuilder.new('l3cs')
    end

    it 'should return a correct URI' do
      @uribuilder.to_s.should eq(
        %Q{http://crwnmis3.staffs.ac.uk/Reporting/Individual;Student+Sets;name;l3cs?&template=Design+Template&weeks=26-42&days=1-5&periods=5-52&width=0&height=0})
    end

    it 'should return a non-zero IO Class' do
      @uribuilder.read.class.should eq(String)
    end
  end

  context 'looking up a module' do

    before do
      @uribuilder = Tableau::UriBuilder.new('CE00758-5', module_lookup: true)
    end

    it 'should return a correct URI' do
      @uribuilder.to_s.should eq(
        %Q{http://crwnmis3.staffs.ac.uk/Reporting/Individual;Modules;name;CE00758-5?&template=Module%20Individual%20SOC&weeks=26-42&days=1-5&periods=5-52&width=0&height=0})
    end

    it 'should return a non-zero IO Class' do
      @uribuilder.read.class.should eq(String)
    end
  end
end
