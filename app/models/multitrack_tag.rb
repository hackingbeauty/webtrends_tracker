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

class MultitrackTag < Tag
  
  named_scope :ordered, :order => "hook"
  
  validates_presence_of :hook
  validates_format_of :hook, :with => /wt_[a-z]{2}_\w{4}/i, :message => "format is invalid. It should look like \"wt_<2-character-product-code>_<4-digit-base-36-number>\""
  validates_length_of :hook, :is => 10
  validate :check_hook_product_abbreviation
  # validates_uniqueness_of :hook

  def check_hook_product_abbreviation
    return if self.hook.nil? or self.product.nil?
    unless self.hook.include?(self.product.abbreviation)
      errors.add(:hook, "product abbreviation is wrong. It should look like \"wt_#{self.product.abbreviation}_####\"")
    end
  end
  
  def multitrack_key_values
    {
      "dcsuri"    => "uri of page",
      "dcsdat"    => "timestamp",
      "WT.vt_sid" => "session id",
      "WT.co_f"   => "unique session id",
      "WT.dl"     => "pageview or multitrack",
      "rand"      => "random cache buster"
    }
  end
  
  def after_create
    multitrack_key_values.each do |k, v |
      self.key_value_pairs.create(:key => k, :value => v, :key_val_type => "WebTrends") 
    end
  end
  
  def story_description
    desc  = "Please create a WebTrends multitrack tag with a hook of #{hook} - #{location}.\n\n"
    desc += "Please verify that the following key/value pairs are present when a multitrack tag is fired for #{hook}:\n"

    defaults = multitrack_key_values.keys

    key_value_pairs.each do |kvp|
      if defaults.include?(kvp.key)
        desc += "#{kvp.key} => #{kvp.value} (default)\n"
      else
        desc += "#{kvp.key} => #{kvp.value}\n"
      end
    end

    desc += "\n**Please note: All values denoted as \"(default)\" DO NOT need to be specified manually - they are automatically generated."
  end
  
end
