class CreateKeyValuePairs < ActiveRecord::Migration
  def self.up
    create_table :key_value_pairs do |t|
      t.string :key
      t.string :value
      t.string :key_val_type
      t.integer :tag_id
      t.timestamps
    end
  end

  def self.down
    drop_table :key_value_pairs
  end
end