class UserRepository < Repository
  belongs_to :user
  alias_method :owner, :user
end


