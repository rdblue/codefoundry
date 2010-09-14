class AddProjectHits < ActiveRecord::Migration
  def self.up
    add_column :projects, :hits, :integer, :default => 0
    remove_column :projects, :user_id
  end

  def self.down
    remove_column :projects, :hits
    add_column :projects, :user_id, :integer
  end
end
