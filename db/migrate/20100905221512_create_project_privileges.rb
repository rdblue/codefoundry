class CreateProjectPrivileges < ActiveRecord::Migration
  def self.up
    create_table :project_privileges do |t|
      t.references :role
      t.references :project
      t.references :user
      t.timestamps
    end
  end

  def self.down
    drop_table :project_privileges
  end
end
