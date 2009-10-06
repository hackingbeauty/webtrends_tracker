class Property < ActiveRecord::Base
  has_many :tag_properties
  has_many :tags, :through => :tag_properties
end