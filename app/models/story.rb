class Story < ActiveResource::Base
  
  attr_accessor :tag, :name, :requested_by, :description
  
  def self.pivotal_token
    "c336965c1c9d3e7da95a04de723afe53"
  end
  
  def self.pivotal_project_id
    "35087"     
  end
  
  self.site = "http://www.pivotaltracker.com/services/v3/projects/#{self.pivotal_project_id}"
  
  def initialize(attrs)
    self.tag = attrs[:tag]
    self.name = "WebTrends - Create/Update multitrack tag for #{tag.location}" 
    self.requested_by = "Jeri Beckley"
    self.description = multitrack_story_description(tag)
  end
  
  def multitrack_story_description(tag)
    desc  = "Please create a WebTrends multitrack tag with a hook of #{tag.hook} - #{tag.location}.\n"
    desc += "Please verify that the following key/value pairs are present when a multitrack tag is fired for #{tag.hook}:\n"
    
    defaults = tag.multitrack_key_values.keys
      
    tag.key_value_pairs.each do |kvp|
      if defaults.include?(kvp.key)
        desc += "#{kvp.key} => <#{kvp.value}> (default)\n"
      else
        desc += "#{kvp.key} => #{kvp.value}\n"
      end
    end
    
    desc += "\n**Please note: All values denoted as \"(default)\" DO NOT need to be specified manually - they are automatically generated."
  end
  
  # 
  # Story.create(:name => "EWWWWWWW", :requested_by => "Jeri Beckley", :description => "green eggs and ham", :project_id => "35087")
  
    
end
