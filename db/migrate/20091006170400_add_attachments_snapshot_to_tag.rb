class AddAttachmentsSnapshotToTag < ActiveRecord::Migration
  def self.up
    add_column :tags, :snapshot_file_name, :string
    add_column :tags, :snapshot_content_type, :string
    add_column :tags, :snapshot_file_size, :integer
  end

  def self.down
    remove_column :tags, :snapshot_file_name
    remove_column :tags, :snapshot_content_type
    remove_column :tags, :snapshot_file_size
  end
end
