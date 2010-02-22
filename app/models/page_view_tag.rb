class PageViewTag < Tag
  validates_presence_of :location
  validates_uniqueness_of :location, :scope => :product_id, :message => 'must be unique for each product'
  
  def validate
    if self.location == 'location'
      errors.add_to_base("Location must not be blank")
    end
  end
end