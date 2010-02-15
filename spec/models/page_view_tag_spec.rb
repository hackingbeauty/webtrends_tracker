# == Schema Information
#
# Table name: tags
#
#  id                    :integer         not null, primary key
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

describe PageViewTag do
  
  before(:each) do
    product = mock_model(Product, :abbreviation => "rh", :null_object => true)
    @valid_attributes = {
      :location => "value for location",
      :description => "value for description",
      :product => product
    }
  end

  it "should create a new instance given valid attributes" do
    PageViewTag.create!(@valid_attributes).should be_true
  end

  it "should accept a content group key/value pair" do
    page_view_tag = PageViewTag.create!(@valid_attributes)
    page_view_tag.key_value_pairs << KeyValuePair.new({:key => "WT.cg_n", :value => "SearchResults", :tag => page_view_tag})
    page_view_tag.key_value_pairs.should have(1).key_value_pairs
  end
    
  it "should not create a Page View tag without a valid product" do
    PageViewTag.new(@valid_attributes.delete(:product)).should_not be_valid
  end  
    
end
