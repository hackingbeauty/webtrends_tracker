class AddProductIdToTags < ActiveRecord::Migration
  def self.up
    add_column :tags, :product_id, :integer
  end

  def self.down
    remove_column :tags, :product_id
  end
end
