require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Property do
  before(:each) do
    @valid_attributes = {
      :key => "value for key",
      :value => "value for value"
    }
  end

  it "should create a new instance given valid attributes" do
    Property.create!(@valid_attributes)
  end
end
