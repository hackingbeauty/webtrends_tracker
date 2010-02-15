require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ScreenShotsController do
  
  describe "on POST to :create" do
    
    before do
      current_user = stub_login(@controller) #fakes a user object

      @uploaded_file = mock
      @params = {
        :tag_id => 1,
        :tag => {
          :snapshot => @uploaded_file
        }
      }
      
      @tag = mock_model(Tag, :null_object => true)
      @tag.stub!(:type => "MultitrackTag")
      Tag.stub!(:find).with("1").and_return(@tag)
      
    end
  
    def do_post
      post :create, @params
    end
  
    describe "update_attributes succeeds" do

      before do
        @tag.stub!(:update_attributes).and_return(true)
      end

      it "should work" do
        do_post
        response.should be_redirect
      end

      it "should call save on the tag" do
        @tag.should_receive(:update_attributes)
        do_post
      end

      it "should set the flash on success" do
        do_post
        flash[:notice].should_not be_blank
      end

    end
    
    describe "update_attributes fails" do
      
      before do
        @tag.stub!(:update_attributes).and_return(nil)
      end
      
      # other tests
      
    end
  
    
  
  end

end