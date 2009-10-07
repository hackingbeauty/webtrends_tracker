class Tag < ActiveRecord::Base
  has_attached_file :snapshot
  
  has_many :tag_properties
  has_many :properties, :through => :tag_properties
  
  belongs_to :product
  
  validates_presence_of :hook
  validates_presence_of :product
  validates_format_of :hook, :with => /wt_[a-z]{2}_\w{4}/i, :message => "format is invalid. It should look like \"wt_<2-character-product-code>_<4-digit-base-36-number>\""
  validates_length_of :hook, :is => 10
  
end
