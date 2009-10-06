class CreateTagProperties < ActiveRecord::Migration
  def self.up
    create_table :tag_properties do |t|
      t.integer :tag_id
      t.integer :property_id

      t.timestamps
    end
  end

  def self.down
    drop_table :tag_properties
  end
end
