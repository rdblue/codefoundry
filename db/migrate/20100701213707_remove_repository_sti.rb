class RemoveRepositorySti < ActiveRecord::Migration
  def self.up
    remove_column :repositories, :type
    add_column :repositories, :param, :string

    add_index :repositories, :param
  end

  def self.down
    add_column :repositories, :type, :string
    remove_index :repositories, :param
    remove_column :repositories, :param
  end
end
