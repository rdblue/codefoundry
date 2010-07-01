class ApplicationController < ActionController::Base
  layout "application"
  protect_from_forgery
  before_filter :set_time_zone
  helper_method :current_user
  rescue_from ActiveRecord::RecordNotFound, :with => :render_404
    
private
  
  def render_404
    render :text => "We couldn't find that page..."
  end

  def current_user_session  
    return @current_user_session if defined?(@current_user_session)  
    @current_user_session = UserSession.find  
  end  
    
  def current_user  
    @current_user = current_user_session && current_user_session.record  
  end  
  
  def require_login
    unless current_user
      store_location
      flash[:notice] = "You must be logged in to access this page"
      redirect_to login_path
      return false
    end
  end

  def store_location
    session[:return_to] = request.request_uri
  end
  
  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

  def set_time_zone
    Time.zone = current_user.time_zone if current_user
  end
end
