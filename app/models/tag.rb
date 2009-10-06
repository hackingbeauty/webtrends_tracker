class Tag < ActiveRecord::Base
  has_attached_file :snapshot
  
  has_many :tag_properties
  has_many :properties, :through => :tag_properties
  
  validates_presence_of :hook
  validates_format_of :hook, :with => /wt_[a-z]{2}_\w{4}/i
  validates_length_of :hook, :is => 10
  
  
  PRODUCTS = %w(ApartmentGuide RentalHouses NewHomeGuide)
  
end
