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
  has_attached_file :snapshot
  
  has_many :key_value_pairs
  belongs_to :product
  
  validates_presence_of :hook
  validates_presence_of :product
  validates_format_of :hook, :with => /wt_[a-z]{2}_\w{4}/i, :message => "format is invalid. It should look like \"wt_<2-character-product-code>_<4-digit-base-36-number>\""
  validates_length_of :hook, :is => 10
  validate :check_hook_product_abbreviation

  def to_param
    "#{id}-#{hook}".downcase.gsub(/\s+/,'')
  end
  
  def check_hook_product_abbreviation
    return if self.hook.nil? or self.product.nil?
    unless self.hook.include?(self.product.abbreviation)
      errors.add(:hook, "product abbreviation is wrong. It should look like \"wt_#{self.product.abbreviation}_####\"")
    end
  end
  
end
