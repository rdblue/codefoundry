class FixRepositoryScm < ActiveRecord::Migration
  def self.up
    # the limit => nil removes the 255 character string limit from db/schema.rb
    change_column :repositories, :scm, :integer, :limit => nil 
  end

  def self.down
    change_column :repositories, :scm, :string
  end
end
