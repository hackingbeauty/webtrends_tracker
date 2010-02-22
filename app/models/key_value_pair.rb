# == Schema Information
#
# Table name: key_value_pairs
#
#  id         :integer         not null, primary key
#  key        :string(255)
#  value      :string(255)
#  key_val_type      :string
#  tag_id     :integer
#  created_at :datetime
#  updated_at :datetime
#

class KeyValuePair < ActiveRecord::Base

  belongs_to :tag
  validates_presence_of :tag
  
  validates_presence_of :key
  validates_presence_of :value
  validates_uniqueness_of :key, :scope => :tag_id
  
  def validate
    if self.key == 'key'
      errors.add_to_base("Key must not be blank")
    end
    if self.value == 'value'
      errors.add_to_base("Value must not be blank")
    end
  end
end
