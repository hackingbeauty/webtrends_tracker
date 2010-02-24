require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Tag do

  describe "key value pair association methods" do
  
    before do
      product = mock_model(Product, :abbreviation => "rh", :null_object => true)
      @valid_attributes = {
        :hook => "wt_rh_1000",
        :location => "value for location",
        :description => "value for description",
        :product => product
      }
    
      @tag = Tag.create(@valid_attributes)
      @tag.key_value_pairs << KeyValuePair.create(:key => 'foo', :value => 'bar')
    end
  
    it "should return a value string for a given key" do  
      @tag.value_str('foo').should eql('bar')
      @tag.value_str('baz').should eql('-')
    end
  
    it "should delete all key value pairs when destroyed" do
      @tag.key_value_pairs.length.should == 1
      lambda { @tag.destroy }.should change { KeyValuePair.count }.by(-1)
    end
  
  end
  
end