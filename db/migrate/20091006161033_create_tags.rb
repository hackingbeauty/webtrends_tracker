class CreateTags < ActiveRecord::Migration
  def self.up
    create_table :tags do |t|
      t.string :hook
      t.string :location
      t.text :description
      t.string :kind
      t.timestamps
    end
  end

  def self.down
    drop_table :tags
  end
end
