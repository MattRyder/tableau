describe "Tableau" do

  before do
    @info = Tableau.module_info('CE00758-5', 2)
  end

  it "should return the correct module info" do
    @info[:code].should eq('CE00758-5')
    @info[:name].should eq('Film Technology 2')
  end

end