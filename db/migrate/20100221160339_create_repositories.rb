class CreateRepositories < ActiveRecord::Migration
  def self.up
    create_table :repositories do |t|
      t.string :type
      t.string :path
      t.integer :owner_id
      t.integer :project_id
      t.integer :size

      t.timestamps
    end
  end

  def self.down
    drop_table :repositories
  end
end
