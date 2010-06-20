class UpdateRepositories < ActiveRecord::Migration
  def self.up
    rename_column :repositories, :owner_id, :user_id
    add_column :repositories, :name, :string
    add_column :repositories, :scm, :string
    add_column :repositories, :summary, :string
  end

  def self.down
    rename_column :repositories, :user_id, :owner_id
    remove_column :repositories, :name
    remove_column :repositories, :scm
    remove_column :repositories, :summary
  end
end
