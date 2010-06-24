class ProjectRepository < Repository
  belongs_to :project
  alias_method :owner, :project
end
