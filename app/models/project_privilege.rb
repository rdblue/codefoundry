class ProjectPrivilege < ActiveRecord::Base
  belongs_to :role
  belongs_to :project
  belongs_to :user

  validates_presence_of :role_id
  validates_presence_of :project_id
  validates_presence_of :user_id
  validates_uniqueness_of :role_id, :scope => [:user_id, :project_id], :message => 'already assigned to this user.'

  def self.model_name
    name = "privilege"
    name.instance_eval do
      def plural;   pluralize;   end
      def singular; singularize; end
      def human;    singularize; end # only for Rails 3
    end
    return name
  end

end
