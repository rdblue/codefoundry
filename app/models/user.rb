class User < ActiveRecord::Base
  has_many :repositories
  acts_as_authentic
  
  default_scope order(:username)
  scope :by_param_scope, lambda { |username| where(:username => username) }

  validates_uniqueness_of :username
  validates_uniqueness_of :email
  
  # Hack to make scope always return single item instead of array
  def self.by_param(param)
    by_param_scope(param).first
  end

  def full_name
    [first_name, last_name].join(' ')
  end

  def to_param
    username
  end
end
