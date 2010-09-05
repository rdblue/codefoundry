class CreateRoles < ActiveRecord::Migration
  def self.up
    create_table :roles do |t|
      t.string :name

      t.timestamps
    end
    
    Role.create :name => 'Administrator' # full access to gui details
    Role.create :name => 'Committer' # commit access, submits/closes issues
    Role.create :name => 'Tester' # submits/closes issues, read access to source
    Role.create :name => 'Reviewer' # read access to source, used with private projects
  end

  def self.down
    drop_table :roles
  end
end
