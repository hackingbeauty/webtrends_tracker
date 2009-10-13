require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Tag do
  
  before(:each) do
    product = mock_model(Product, :abbreviation => "rh", :null_object => true)
    @valid_attributes = {
      :hook => "wt_rh_1000",
      :location => "value for location",
      :description => "value for description",
      :product => product
    }
  end

  it "should create a new instance given valid attributes" do
    Tag.create!(@valid_attributes)
  end
  
  it "should not create a new instance without a hook" do
    @valid_attributes.delete(:hook)
    Tag.new(@valid_attributes).should_not be_valid
  end
  
end
