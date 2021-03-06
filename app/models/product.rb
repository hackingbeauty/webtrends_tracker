# == Schema Information
#
# Table name: products
#
#  id           :integer         not null, primary key
#  name         :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#  abbreviation :string(255)
#

class Product < ActiveRecord::Base
  
  has_many :multitrack_tags
  has_many :page_view_tags
  has_many :tags, :dependent => :destroy
  
  def to_param
    "#{id}-#{name}".downcase.gsub(/\s+/,'')
  end
  
  def abbreviation=(ab)
    self[:abbreviation] = ab.downcase
  end
  
end
