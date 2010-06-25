class AddProjectParam < ActiveRecord::Migration
  def self.up
    add_column :projects, :param, :string
    add_index :projects, :param
  end

  def self.down
    remove_index :projects, :param
    remove_column :projects, :param
  end
end
