require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Tag do
  before(:each) do
    @valid_attributes = {
      :hook => "value for hook",
      :location => "value for location",
      :description => "value for description"
    }
  end

  it "should create a new instance given valid attributes" do
    Tag.create!(@valid_attributes)
  end
  
  it "should not create a new instance without a hook" do
    @valid_attributes.delete(:hook)
    tag = Tag.create(@valid_attributes)
    tag.should have(1).errors_on(:hook)
  end
  
end
