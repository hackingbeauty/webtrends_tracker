require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe TagProperty do
  before(:each) do
    @valid_attributes = {
      :tag_id => 1,
      :property_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    TagProperty.create!(@valid_attributes)
  end
end
