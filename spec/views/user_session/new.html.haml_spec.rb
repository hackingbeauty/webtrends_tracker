require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "user_sessions/new" do

  before :each do
    Authlogic::Session::Base.controller = Authlogic::ControllerAdapters::RailsAdapter.new(ApplicationController.new)
    @user_session = UserSession.new("email" => "test@example.com", "password" => "12345")
    assigns[:user_session] = @user_session
    render "user_sessions/new"
  end
  
  it "should render the form correctly" do
    response.should have_tag("form[action=?]", user_session_path) do
      with_tag("input[type=text][name=?][value=?]", "user_session[email]", "test@example.com")
      with_tag("input[type=password][name=?]", "user_session[password]")
      with_tag("input[type=submit]")
    end
  end
  
end
