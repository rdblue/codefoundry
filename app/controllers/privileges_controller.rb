class PrivilegesController < ApplicationController
  # for privilegable_path()
  helpers
  include PrivilegesHelper

  before_filter :get_privilegable
  before_filter :get_form_requirements, :only => [:new, :create, :edit, :update]

  # GET /privileges
  # GET /privileges.xml
  def index
    @privileges = @privilegable.privileges

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @privileges }
    end
  end

  # GET /privileges/1
  # GET /privileges/1.xml
  def show
    @privilege = @privilegable.privileges.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @privilege }
    end
  end

  # GET /privileges/new
  # GET /privileges/new.xml
  def new
    @privilege = @privilegable.privileges.build

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @privilege }
    end
  end

  # GET /privileges/1/edit
  def edit
    @privilege = @privilegable.privileges.find(params[:id])
  end

  # POST /privileges
  # POST /privileges.xml
  def create
    @privilege = @privilegable.privileges.build(params[:privilege])

    respond_to do |format|
      if @privilege.save
        format.html { redirect_to(privilegable_path, :notice => 'Privilege was successfully created.') }
        format.xml  { render :xml => @privilege, :status => :created, :location => @privilege }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @privilege.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /privileges/1
  # PUT /privileges/1.xml
  def update
    @privilege = @privilegable.privileges.find(params[:id])

    respond_to do |format|
      if @privilege.update_attributes(params[:privilege])
        format.html { redirect_to(privilegable_path, :notice => 'Privilege was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @privilege.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /privileges/1
  # DELETE /privileges/1.xml
  def destroy
    @privilege = @privilegable.privileges.find(params[:id])
    @privilege.destroy

    respond_to do |format|
      format.html { redirect_to(privilegable_path) }
      format.xml  { head :ok }
    end
  end

private
  # Find the most specific privilegable object
  def get_privilegable
    if params[:repository_id]
      @repository = Repository.by_param params[:repository_id]
      @privilegable = @repository
    elsif params[:project_id]
      @project = Project.by_param params[:project_id]
      @privilegable = @project
    else
      raise UnknownPrivilegableObject
    end
  end

  def get_form_requirements
    @roles = Role.all
    @users = User.all
  end
end

class UnknownPrivilegableObject < Exception; end
