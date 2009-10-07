class KeyValuePair < ActiveRecord::Base
  belongs_to :tag
  validates_presence_of :tag
end