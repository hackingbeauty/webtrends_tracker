# == Schema Information
#
# Table name: key_value_pairs
#
#  id         :integer         not null, primary key
#  key        :string(255)
#  value      :string(255)
#  tag_id     :integer
#  created_at :datetime
#  updated_at :datetime
#

class KeyValuePair < ActiveRecord::Base

  belongs_to :tag
  validates_presence_of :tag
  
  validates_presence_of :key
  validates_presence_of :value
  
end
