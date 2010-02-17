require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SpreadsheetsController do
  
  describe "on GET to :index" do
    
    before :each do
      # simulate a logged in user.
      current_user = stub_login(@controller)
    end
    
    def do_get
      get :index
    end
    
    it "should be successful" do
      do_get
      response.should be_success
    end
    
    it "should return a comma separated file of tags" do
      kvp = mock_model(KeyValuePair, :key => 'foo', :bar => 'bar')
      tag = mock_model(Tag, :hook => 'wt_rh_1000', :location => 'blah', :description => 'desc', :key_value_pairs => [kvp], :value_str => 'bar')
      product = mock_model(Product, :abbreviation => "rh", :tags => [tag], :name => 'rentalhouses')
      tag.stub!(:product => product)
      Product.should_receive(:all).and_return([product])
      do_get
      response.body.should include('product,hook,foo')
      response.body.should include('rentalhouses,wt_rh_1000,bar')
    end
    
    it "should have a content-type of text/csv in the headers" do
      do_get
      response.headers["Content-Type"].should eql("text/csv; charset=utf-8")
    end
    
    it "should have a content-disposition of attachment with the date in the headers" do
      do_get
      response.headers["Content-Disposition"].should eql("attachment; filename=summary-from-#{Date.today}.csv")
    end
    
  end
  
end