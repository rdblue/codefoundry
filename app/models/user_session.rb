class UserSession < Authlogic::Session::Base
  # rails 3 beta4 bugfix for authlogic 2.1.5
  def to_key
    new_record? ? nil : [ self.send(self.class.primary_key) ]
  end
end
