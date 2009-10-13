require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe TagsController do
  
  describe "on GET to :index" do
    
    before :each do
      # simulate a logged in user.
      current_user = mock_model(User)
      @controller.stub!(:current_user).and_return(current_user)
    end
    
    def do_get
      get :index
    end
    
    it "should be successful" do
      do_get
      response.should be_success
    end
    
    it "should protect from unauthenticated access" do
      @controller.stub!(:current_user).and_return(nil)
      do_get
      response.should redirect_to(new_user_session_path)
    end
    
  end
  
end