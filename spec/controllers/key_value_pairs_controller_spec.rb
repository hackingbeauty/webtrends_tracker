require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe KeyValuePairsController do

  before :each do
    stub_login(@controller)
    @tag = MultitrackTag.create! :hook => "wt_ag_0001", :product => mock_model(Product, :abbreviation => "ag"), :location => "location"
  end

  describe "on POST to :create" do
    
    before :each do
      @params = {
        :key_value_pair => {
          :tag_id => @tag.id,
          :key => "some key",
          :value => "some value"
        }
      }
    end
  
    def do_post
      post :create, @params
    end
    
    it "should create a new key value pair" do
      lambda { do_post }.should change { KeyValuePair.count }.by(1)
    end
    
  end
  
  describe "on DELETE to :destroy" do
    
    before :each do
      @key_value_pair = mock_model(KeyValuePair, :tag => @tag)
      @key_value_pair.stub!(:destroy)
      KeyValuePair.stub!(:find).with(@key_value_pair.id.to_s).and_return(@key_value_pair)
    end
    
    def do_delete
      delete :destroy, :id => @key_value_pair.id
    end
    
    it "should destroy the key value pair" do
      @key_value_pair.should_receive(:destroy)
      do_delete
    end
    
    it "should redirect" do
      do_delete
      response.should be_redirect
    end
    
  end


end