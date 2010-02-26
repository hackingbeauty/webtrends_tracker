require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Story do
  
  it "should return a valid token" do
    Story.pivotal_token.should == "c336965c1c9d3e7da95a04de723afe53"
  end
    
  describe "pivotal tracker methods" do
    before do
      t = mock("tag", :product => mock("product", :pivotal_project_id => "12345"), :nil_object => true, :location => "location", :hook => "hook", :multitrack_key_values => {}, :key_value_pairs => [], :story_description => 'desc')
      @story = Story.new(:tag => t)
    end
    
    it "should have the proper pivotal project id based on product" do
      @story.pivotal_project_id.should == "12345"
    end
    
    it "should access the correct API site" do
      @story.site.should == "http://www.pivotaltracker.com/services/v3/projects/12345/stories"
    end
  end
  
  describe "defaults after new is called" do

    before do
      @tag = mock("tag", 
        :nil_object => true, 
        :location => "Search results page", 
        :hook => 'wt_ag_0001',
        :type => 'tag type',
        :story_description => 'desc',
        :multitrack_key_values => {
          'WT.dl' => 'pageview or multitrack', 
          'rand' => 'random cache buster'
        },
        :key_value_pairs => [
          mock('kvp', :key => 'clicktype', :value => 'search'),
          mock('kvp', :key => 'WT.dl', :value => 'pageview or multitrack'),
          mock('kvp', :key => 'rand', :value => 'random cache buster')
        ]
      )
      @story = Story.new({ :tag => @tag })
    end

    it "should have multitrack values" do
      @story.tag.should == @tag
      @story.name.should == "WebTrends - Create/Update tag type for #{@tag.location}" 
      @story.requested_by.should == "Jeri Beckley" 
      @story.description.should == @tag.story_description
    end
    
    it "should be valid with a tag" do
      @story.valid?.should be_true
    end
    
    it "should be invalid without a tag" do
      @story = Story.new
      @story.valid?.should be_false
    end
  end
  
  describe "post_to_pivotal" do
    
    before do
      @res = mock('pivotal response', :class => Net::HTTPOK)
      Net::HTTP.stub!(:start).and_return(@res)
    end
    
    it "should return true if there are no problems" do
      t = mock('tag', :location => 'some location', :story_description => 'desc')
      s = Story.new(:tag => t)
      s.stub!(:pivotal_project_id).and_return('12345')
      s.post_to_pivotal.should be_true
    end
  
    it "should return false if the story is invalid" do
      s = Story.new() # no tag
      s.post_to_pivotal.should be_false
    end
  
    describe 'without a 200 status code' do
      before do
        @res.stub!(:class => Net::HTTPError)
        @res.stub!(:body => 'some error message')
        @tag = mock('tag', :location => 'some location', :story_description => 'desc')
        @story = Story.new(:tag => @tag)
        @story.stub!(:pivotal_project_id).and_return('12345')
      end
      
      it "should return false" do
        @story.post_to_pivotal.should be_false
      end
  
      it "should assign errors to the story" do
        @res.stub!(:body => '<errors><error>Something went wrong</error><error>BOOM!</error></errors>')
        @story.post_to_pivotal.should be_false
        @story.errors.full_messages.include?("Something went wrong").should be_true
        @story.errors.full_messages.include?("BOOM!").should be_true
      end
      
    end
  end
  
end
