require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe StoriesController do

  describe  "on GET to :new" do
    
    before :each do
      # simulate a logged in user.
      current_user = stub_login(@controller)
    end
    
    def do_get(params={})
      get :new, params
    end
    
    it "should be successful" do
      tag = mock("tag")
      Tag.should_receive(:find_by_id).with("1234").and_return(tag)
      Story.should_receive(:new).with(:tag => tag)
      do_get({:tag_id => "1234"})
      response.should be_success
    end
    
    it "should be successful without a tag id in the url params" do
      tag = mock("tag")
      Tag.should_receive(:find_by_id).with(nil).and_return(nil)
      Story.should_receive(:new).with(:tag => nil)
      do_get
      response.should be_success
    end
  
  end

  describe  "on POST to :create" do
    
    before :each do
      # simulate a logged in user.
      current_user = stub_login(@controller)
      
      @tag = mock('tag', :id => '1234', :nil_object => true)
      Tag.should_receive(:find_by_id).with("1234").and_return(@tag)
      @params = { :tag => {:id => "1234"}, :story => {} }
      @new_story = mock('new story')
      Story.should_receive(:new).and_return(@new_story)
    end
    
    def do_post(params={})
      post :create, params
    end
    
    it "successful create" do
      @new_story.should_receive(:post_to_pivotal).and_return(true)    
      @controller.should_receive(:url_for).with(@tag).and_return('tag_path')
      do_post @params
    end
  
    it "unsuccessful create" do
      @new_story.should_receive(:post_to_pivotal).and_return(false)
      @controller.should_receive(:render).with(:action => 'new')
      do_post @params
    end
    
  
  end

end