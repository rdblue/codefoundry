require 'grit'

class Repository < ActiveRecord::Base
  # SCM config
  GIT_SCM = 1
  SVN_SCM = 2

  belongs_to :project
  belongs_to :user

  default_scope order(:name)
  scope :by_param_scope, lambda { |name| where(:param => name) }

  validates_presence_of :name
  validate :user_or_project_repository
  validates_uniqueness_of :name, :scope => :user_id, :if => :user_repository?
  validates_uniqueness_of :name, :scope => :project_id, :if => :project_repository?
  before_save :save_param
  before_create :create_repository
  after_destroy :destroy_repository

  # Hack to make scope always return single item instead of array
  def self.by_param(param)
    by_param_scope(param).first
  end

  # Class methods invoked for repository operations. These are usually 
  # processed asychronously. Keep in mind that class variables like
  # repository_base_path aren't available when processed asynchronously
  # because they're executed in a different process.
  class << self
    # Create a bare git repository
    def create_git_repository(path)
      if !File.exist? path
        Grit::Repo.init_bare(path)
      end
    end

    # TODO: implement
    def fork_git_repository
    end

    # Move a git repository to the archive
    # out of public view
    def destroy_git_repository(repository_archive_path, repository_path)
      repository_name = repository_path.split(File::SEPARATOR)[-1]
      owner_name = repository_path.split(File::SEPARATOR)[-2]
      archive_dir = File.join(repository_archive_path, 'git', owner_name)
      FileUtils.mkdir_p(File.join(archive_dir))
      FileUtils.mv repository_path, archive_dir
    end

    # TODO: implement
    def create_svn_repository(path)
    end

    # TODO: implement
    def destroy_svn_repository(path)
    end
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

  def scm_str
    case scm
      when GIT_SCM then 'git'
      when SVN_SCM then 'svn'
      else 
        raise UnsupportedSCMError
    end
  end

  def full_path
    case scm
      when GIT_SCM
        File.join Settings.repository_base_path, 'git', owner.param, "#{param}.git"
      when SVN_SCM
        File.join Settings.repository_base_path, 'svn', owner.param, self.param
      else
        raise UnsupportedSCMError
    end
  end

  # Initialize the repository on disk
  def create_repository
    case scm
    when GIT_SCM
      self.class.delay.create_git_repository(full_path)
    when SVN_SCM
      self.class.delay.create_svn_repository(full_path)
    else
      raise UnsupportedSCMError
    end
  end

  # Move repository to an archive
  def destroy_repository
    case scm
      when GIT_SCM
        self.class.delay.destroy_git_repository(Settings.repository_archive_path, full_path)
      when SVN_SCM
      else
        raise UnsupportedSCMError
    end
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
    [['git', GIT_SCM], ['svn', SVN_SCM]]
  end
end

class IncoherantRepositoryError < Exception; end
class UnsupportedSCMError < Exception; end
