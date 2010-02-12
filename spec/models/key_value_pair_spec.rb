# == Schema Information
#
# Table name: key_value_pairs
#
#  id         :integer         not null, primary key
#  key        :string(255)
#  value      :string(255)
#  key_val_type      :string
#  tag_id     :integer
#  created_at :datetime
#  updated_at :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe KeyValuePair do
  before(:each) do
    tag = mock_model(Tag)
    @valid_attributes = {
      :key => "WT.dl",
      :value => "multitrack",
      :tag => tag
    }
  end

  it "should create a new instance given valid attributes" do
    KeyValuePair.create!(@valid_attributes)
  end
end
