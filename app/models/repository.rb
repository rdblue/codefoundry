class Repository < ActiveRecord::Base
end

class UserRepository < Repository
  belongs_to :user
end

class ProjectRepository < Repository
  belongs_to :project
end
