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
  
  named_scope :search, lambda { |search_string|
    {
      :conditions =>
        [ "(hook LIKE :search_string) or (location LIKE :search_string)",
          {:search_string => "%#{search_string}%"}
        ]
    }
  }
  
  has_attached_file :snapshot, :styles => { :normal => "975x975>" }
  
  has_many :key_value_pairs, :order => "'key'", :dependent => :destroy
  belongs_to :product
    
  validates_presence_of :product
  
  def value_str(key)
    @key_value_pairs ||= self.key_value_pairs  
    key_names = @key_value_pairs.map(&:key)
    if key_names.include?(key)
      kvp = @key_value_pairs.select {|x| x.key == key }.first
      return kvp.value if kvp
    end
    return '-'
  end
  
  def self.per_page
    20
  end
  
  def self.list(page=1)
    paginate(:page => page)
  end
  
end
