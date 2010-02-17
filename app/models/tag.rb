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
  
  attr_accessor :kind
  
  has_attached_file :snapshot, :styles => { :normal => "975x975>" }
  
  has_many :key_value_pairs, :order => "'key'"
  belongs_to :product
    
  validates_presence_of :product
  
  def multitrack_key_values
    {
      "dcsuri"    => "uri of page",
      "dcsdat"    => "timestamp",
      "WT.vt_sid" => "session id",
      "WT.co_f"   => "unique session id",
      "WT.dl"     => "pageview or multitrack"
    }
  end
  
  def after_create
    if self.kind == "multitrack"
      multitrack_key_values.each do |k, v |
        self.key_value_pairs.create(:key => k, :value => v)
      end
    end
  end
  
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
    Tag.paginate(:page => page, :order => :type)
  end
  
end
