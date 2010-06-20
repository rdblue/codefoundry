class User < ActiveRecord::Base
  #has_many :repositories
  acts_as_authentic
end
