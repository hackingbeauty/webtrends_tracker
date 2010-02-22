class AddPivotalProjectIdToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :pivotal_project_id, :integer
  end

  def self.down
    remove_column :products, :pivotal_project_id
  end
end
