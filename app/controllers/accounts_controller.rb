class AccountsController < ApplicationController
  before_filter :require_login

  # GET /account
  # GET /account.xml
  def show
    @account = current_user

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @account }
    end
  end

  # GET /account/edit
  def edit
    @account = current_user
  end

  # PUT /account
  # PUT /account.xml
  def update
    @account = current_user

    respond_to do |format|
      if @account.update_attributes(params[:account])
        format.html { redirect_to(account_path, :notice => 'Account was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @account.errors, :status => :unprocessable_entity }
      end
    end
  end
end
