# == Schema Information
#
# Table name: tags
#
#  id                    :integer         not null, primary key
#  hook                  :string(255)
#  location              :string(255)
#  description           :text
#  created_at            :datetime
#  updated_at            :datetime
#  snapshot_file_name    :string(255)
#  snapshot_content_type :string(255)
#  snapshot_file_size    :integer
#  product_id            :integer
#

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
  
  it "should not create a new tag if the hook already exists" do
    Tag.create!(@valid_attributes)

    # error
    tag2 = Tag.new(@valid_attributes)
    tag2.should have(1).error_on(:hook)
    
    # resolution
    tag2.hook = "wt_rh_1001"
    tag2.should be_valid
  end
  
  it "should retrieve the key_value_pairs association" do
    tag = Tag.create!(@valid_attributes)
    tag.key_value_pairs.should == []
  end
  
end
