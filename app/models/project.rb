class Project < ActiveRecord::Base
  has_many :repositories
  belongs_to :user
end
