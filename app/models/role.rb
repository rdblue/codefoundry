class Role < ActiveRecord::Base
  default_scope order(:name)
end
