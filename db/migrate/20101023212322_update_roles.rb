class UpdateRoles < ActiveRecord::Migration
  def self.up
    add_column :roles, :edit_project, :boolean, :default => false
    add_column :roles, :add_others, :boolean, :default => false
    add_column :roles, :create_delete_repositories, :boolean, :default => false
    add_column :roles, :commit, :boolean, :default => false
    add_column :roles, :checkout, :boolean, :deafult => false

    r = Role.find_by_name 'Administrator'
    r.edit_project = true
    r.add_others = true
    r.create_delete_repositories = true
    r.commit = true
    r.checkout = true
    r.save!

    r = Role.find_by_name 'Committer'
    r.commit = true
    r.checkout = true
    r.save!

    r = Role.find_by_name 'Tester'
    r.checkout = true
    r.save!

    r = Role.find_by_name 'Reviewer'
    r.checkout = true
    r.save!
  end

  def self.down
    remove_column :roles, :edit_project
    remove_column :roles, :add_others
    remove_column :roles, :create_delete_repositories
    remove_column :roles, :commit
    remove_column :roles, :checkout
  end
end
