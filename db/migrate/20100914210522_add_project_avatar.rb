class AddProjectAvatar < ActiveRecord::Migration
  def self.up
    add_column :projects, :avatar_file_name, :string
    add_column :projects, :avatar_content_type, :string
    add_column :projects, :avatar_file_size, :integer
    add_column :projects, :avatar_updated_at, :datetime
  end

  def self.down
    remove_column :projects, :avatar_file_name
    remove_column :projects, :avatar_content_type
    remove_column :projects, :avatar_file_size
    remove_column :projects, :avatar_updated_at
  end
end
