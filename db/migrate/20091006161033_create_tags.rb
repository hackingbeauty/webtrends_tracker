class CreateTags < ActiveRecord::Migration
  def self.up
    create_table :tags do |t|
      t.string :hook
      t.string :location
      t.text :description
      t.string :type
      t.integer :product_id
      t.string :snapshot_file_name
      t.string :snapshot_content_type
      t.integer :snapshot_file_size
      t.timestamps
    end
  end

  def self.down
    drop_table :tags
  end
end
