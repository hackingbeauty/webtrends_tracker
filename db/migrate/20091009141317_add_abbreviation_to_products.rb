class AddAbbreviationToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :abbreviation, :string
  end

  def self.down
    remove_column :products, :abbreviation
  end
end
