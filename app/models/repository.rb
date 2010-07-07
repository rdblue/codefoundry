class Repository < ActiveRecord::Base
  belongs_to :project
  belongs_to :user

  default_scope order(:name)
  scope :by_param_scope, lambda { |name| where(:param => name) }

  validates_presence_of :name
  validate :user_or_project_repository
  validates_uniqueness_of :name, :scope => :user_id, :if => :user_repository?
  validates_uniqueness_of :name, :scope => :project_id, :if => :project_repository?
  before_save :save_param

  # Hack to make scope always return single item instead of array
  def self.by_param(param)
    by_param_scope(param).first
  end

  # for nice urls
  def to_param
    result = "#{self.name}"
    result.gsub!(/[^\w_ \-]+/i, '') # Remove unwanted chars.
    result.gsub!(/[ \-]+/i, '-') # No more than one of the separator in a row.
    result.gsub!(/^\-|\-$/i, '') # Remove leading/trailing separator.
    result.mb_chars.downcase.to_s
  end

  def save_param
    self.param = to_param
  end
  
  def user_or_project_repository
    raise IncoherantRepositoryError if user_id and project_id
  end

  def user_repository?
    return true if user_id
    return false
  end

  def project_repository?
    return true if project_id
    return false
  end

  def owner
    return user if user_repository?
    return project if project_repository?
  end

  def available_scms
    [['git', 1], ['svn', 2]]
  end
end

class IncoherantRepositoryError < Exception; end
