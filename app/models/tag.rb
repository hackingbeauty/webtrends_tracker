# == Schema Information
#
# Table name: tags
#
#  id                    :integer         not null, primary key
#  hook                  :string(255)
#  location              :string(255)
#  description           :text
#  created_at            :datetime
#  updated_at            :datetime
#  snapshot_file_name    :string(255)
#  snapshot_content_type :string(255)
#  snapshot_file_size    :integer
#  product_id            :integer
#

class Tag < ActiveRecord::Base
  
  has_attached_file :snapshot, :styles => { :normal => "975x975>" }
  
  has_many :key_value_pairs, :order => "'key'"
  belongs_to :product
    
  validates_presence_of :product
  
end
