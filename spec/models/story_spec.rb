require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Story do
  
  it "should return a valid token" do
    Story.pivotal_token.should == "c336965c1c9d3e7da95a04de723afe53"
  end
  
  describe "pivotal tracker methods" do
    before do
      t = mock("tag", :product => mock("product", :pivotal_project_id => "12345"), :nil_object => true, :location => "location", :hook => "hook", :multitrack_key_values => {}, :key_value_pairs => [])
      @story = Story.new(:tag => t)
    end
    
    it "should have the proper pivotal project id based on product" do
      @story.pivotal_project_id.should == "12345"
    end
    
    it "should access the correct API site" do
      @story.site.should == "http://www.pivotaltracker.com/services/v3/projects/12345"
    end
  end
  
  describe "defaults after new is called" do

    before do
      @tag = mock("tag", 
        :nil_object => true, 
        :location => "Search results page", 
        :hook => 'wt_ag_0001', 
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
      @story.name.should == "WebTrends - Create/Update multitrack tag for #{@tag.location}" 
      @story.requested_by.should == "Jeri Beckley"
    
      desc  = "Please create a WebTrends multitrack tag with a hook of wt_ag_0001 - Search results page.\n\n"
      desc += "Please verify that the following key/value pairs are present when a multitrack tag is fired for wt_ag_0001:\n"
      desc += "clicktype => search\n"
      desc += "WT.dl => <pageview or multitrack> (default)\n"
      desc += "rand => <random cache buster> (default)\n"
      desc += "\n**Please note: All values denoted as \"(default)\" DO NOT need to be specified manually - they are automatically generated."
    
      @story.description.should == desc
    end
    
    it "should be valid with a tag" do
      @story.valid?.should be_true
    end
    
    it "should be invalid without a tag" do
      @story = Story.new
      @story.valid?.should be_false
    end
  end
  
end
