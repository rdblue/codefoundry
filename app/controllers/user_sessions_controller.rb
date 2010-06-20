class UserSessionsController < ApplicationController
  def new
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new params[:user_session]
    if @user_session.save  
      flash[:notice] = "Successfully logged in."  
      redirect_to root_url  
    else
      flash.now[:notice] = "Invalid username or password"
      # don't indicate what part of the authentication failed
      @user_session.errors.clear 
      render :action => 'new'  
    end  
  end

  def destroy  
    @user_session = UserSession.find  
    @user_session.destroy  
    flash[:notice] = "Successfully logged out."  
    redirect_to root_url  
  end  

end
