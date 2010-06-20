class ApplicationController < ActionController::Base
  layout "application"
  protect_from_forgery
  helper_method :current_user  
    
private  
  def current_user_session  
    return @current_user_session if defined?(@current_user_session)  
    @current_user_session = UserSession.find  
  end  
    
  def current_user  
    @current_user = current_user_session && current_user_session.record  
  end  
end
