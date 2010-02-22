require 'net/http'
require 'uri'

class Story < ActiveRecord::Base
  
  attr_accessor :tag, :name, :requested_by, :description
  
  validates_presence_of :tag
  
  def self.columns; @columns ||= []; end # allow tableless active record model, for validations
  
  def self.pivotal_token
    "c336965c1c9d3e7da95a04de723afe53"
  end
  
  def pivotal_project_id
    35087 #self.tag.product.pivotal_project_id
  end
  
  def site
    "http://www.pivotaltracker.com/services/v3/projects/#{pivotal_project_id}/stories"
  end
  
  def post_to_pivotal
    return false unless self.valid?

    xml = "
    <story>
      <name>#{self.name}</name>
      <description>#{self.description}</description>
      <requested_by>#{self.requested_by}</requested_by>
    </story>"
    
    status = ''
    resource_uri = URI.parse(self.site)
    response = Net::HTTP.start(resource_uri.host, resource_uri.port) do |http|
      status = http.post(resource_uri.path, xml, { 
        'X-TrackerToken' => Story.pivotal_token,
        'Content-Type' => 'text/xml'
      })
    end
    
    unless response.class == Net::HTTPOK
      doc = Nokogiri::XML(response.body)
      doc.css('error').each {|x| self.errors.add_to_base(x.text) }
      return false
    end
    
    true # 200 OK
  end
  
  def after_initialize
    if tag
      self.name ||= "WebTrends - Create/Update multitrack tag for #{tag.location}" 
      self.description ||= multitrack_story_description(tag)
    end
    self.requested_by ||= "Jeri Beckley"
  end
  
  def multitrack_story_description(tag)
    desc  = "Please create a WebTrends multitrack tag with a hook of #{tag.hook} - #{tag.location}.\n\n"
    desc += "Please verify that the following key/value pairs are present when a multitrack tag is fired for #{tag.hook}:\n"
    
    defaults = tag.multitrack_key_values.keys
      
    tag.key_value_pairs.each do |kvp|
      if defaults.include?(kvp.key)
        desc += "#{kvp.key} => #{kvp.value} (default)\n"
      else
        desc += "#{kvp.key} => #{kvp.value}\n"
      end
    end
    
    desc += "\n**Please note: All values denoted as \"(default)\" DO NOT need to be specified manually - they are automatically generated."
  end
    
end
