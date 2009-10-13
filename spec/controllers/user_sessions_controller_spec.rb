require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe UserSessionsController do

  describe "on GET to :new" do
    
    before :each do
      get :new
    end
    
    it do
      response.should be_success
    end
    
    it do
      response.should render_template("user_sessions/new")
    end
    
    it "should assign to the user_session variable" do
      assigns[:user_session].should_not be_nil
    end
    
  end
  
  describe "on POST to :create" do
    
    before :each do
      User.create!(:email => "test@example.com", :password => "password12345", :password_confirmation => "password12345")
      @controller.instance_eval{flash.stub!(:sweep)} # to preserve flash.now testing.

      Authlogic::Session::Base.controller = Authlogic::ControllerAdapters::RailsAdapter.new(@controller)

      @params = { :user_session => { :email => "test@example.com", :password => "password12345" } }
    end
    
    def do_post
      post :create, @params
    end
    
    it "should log in the user" do
      do_post
      @controller.send(:current_user).should_not be_nil
    end
    
    it "should redirect the user after logging in" do
      do_post
      response.should be_redirect
    end
    
    [:email, :password].each do |param|
      it "should re-render the login form if #{param} is missing" do
        @params[:user_session][param] = nil
        do_post
        response.should render_template("user_sessions/new")
        flash.now[:error].should_not be_blank
      end
    end
    
    it "should re-render the login form if both email and password are missing" do
      @params[:user_session][:email] = nil
      @params[:user_session][:password] = nil
      do_post
      response.should render_template("user_sessions/new")
      flash.now[:error].should_not be_blank
    end
    
    it "should re-render the login form if the credentials are invalid" do
      @params[:user_session][:password] = "wrong password"
      do_post
      response.should render_template("user_sessions/new")
      flash.now[:error].should eql("Invalid Credentials")
    end
    
  end

  describe "on DELETE to :destroy" do

    before :each do
      @current_user_session = mock("current_user_session", :null_object => true)
      @current_user_session.stub!(:destroy)
      @controller.stub(:current_user_session).and_return(@current_user_session)
    end

    def do_delete
      delete :destroy
    end

    it "should delete the user session" do
      @current_user_session.should_receive(:destroy)
      do_delete
    end
    
    it "should redirect" do
      do_delete
      response.should be_redirect
    end
    
  end

end