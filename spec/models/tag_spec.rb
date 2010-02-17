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
  
  it "should return a value string for a given key" do
    tag = Tag.create(@valid_attributes)
    tag.key_value_pairs << KeyValuePair.create(:key => 'foo', :value => 'bar')
    
    tag.value_str('foo').should eql('bar')
    tag.value_str('baz').should eql('-')
  end
  
end