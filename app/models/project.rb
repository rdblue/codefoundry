class Project < ActiveRecord::Base
  has_many :repositories
  has_many :project_privileges
  has_many :users, :through => :project_privileges
  alias_method :privileges, :project_privileges
  belongs_to :user
  
  default_scope order(:name)
  scope :by_param_scope, lambda { |param| where(:param => param)}
  scope :newest, lambda { with_exclusive_scope {order('created_at DESC')} }
  scope :by_hits, lambda { with_exclusive_scope {order('hits DESC')} }

  validates_presence_of :name
  validates_uniqueness_of :param
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
  
  # Is this user an owner?
  # TODO: add privilege fields and check those instead
  def owner?(arg)
    return true if users.include? arg
    return false
  end
end
