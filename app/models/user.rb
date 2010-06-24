class User < ActiveRecord::Base
  has_many :repositories
  acts_as_authentic

  def full_name
    [first_name, last_name].join(' ')
  end
end
