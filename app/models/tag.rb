class Tag < ActiveRecord::Base
  has_attached_file :snapshot
  
  has_many :tag_properties
  has_many :properties, :through => :tag_properties
  
  validates_presence_of :hook
  
  PRODUCTS = %w(ApartmentGuide RentalHouses NewHomeGuide)
  
end
