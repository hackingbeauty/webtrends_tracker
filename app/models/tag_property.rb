class TagProperty < ActiveRecord::Base
  belongs_to :tag
  belongs_to :property
end