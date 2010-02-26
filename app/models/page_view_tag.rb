class PageViewTag < Tag
  validates_presence_of :location
  validates_uniqueness_of :location, :scope => :product_id, :message => 'must be unique for each product'
  
  named_scope :ordered, :order => "location"
  
  def validate
    if self.location == 'location'
      errors.add_to_base("Location must not be blank")
    end
  end
  
  def story_description
    desc  = "Please create a WebTrends page view tag for the #{location} page.\n\n"
    desc += "Please verify that the following key/value pairs are present when this page view tag is fired:\n"

    key_value_pairs.each do |kvp|
      desc += "#{kvp.key} => #{kvp.value}\n"
    end

    return desc
  end
  
end