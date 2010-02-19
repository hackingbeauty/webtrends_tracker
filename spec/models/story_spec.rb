require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Story do

  it "should access the correct API site" do
    Story.site.to_s.should == "http://www.pivotaltracker.com/services/v3/projects/35087"
  end
  
  it "should return a valid token" do
    Story.pivotal_token.should == "c336965c1c9d3e7da95a04de723afe53"
  end
  
  it "should return the correct WebTrends project id" do
    Story.pivotal_project_id.should == "35087"
  end
  
  describe "defaults after new is called" do

    it "should have multitrack values" do
      t = mock("tag", 
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
      s = Story.new({ :tag => t })
      s.tag.should == t
      s.name.should == "WebTrends - Create/Update multitrack tag for #{t.location}" 
      s.requested_by.should == "Jeri Beckley"
    
      desc  = "Please create a WebTrends multitrack tag with a hook of wt_ag_0001 - Search results page.\n\n"
      desc += "Please verify that the following key/value pairs are present when a multitrack tag is fired for wt_ag_0001:\n"
      desc += "clicktype => search\n"
      desc += "WT.dl => <pageview or multitrack> (default)\n"
      desc += "rand => <random cache buster> (default)\n"
      desc += "\n**Please note: All values denoted as \"(default)\" DO NOT need to be specified manually - they are automatically generated."
    
      s.description.should == desc
    end
    
  end
  
end
