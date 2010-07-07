class RepositoriesController < ApplicationController
  before_filter :get_owner

  # GET /repositories
  # GET /repositories.xml
  def index
    @repositories = @owner.repositories

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @repositories }
    end
  end

  # GET /repositories/1
  # GET /repositories/1.xml
  def show
    @repository = @owner.repositories.by_param params[:id]

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @repository }
    end
  end

  # GET /repositories/new
  # GET /repositories/new.xml
  def new
    @repository = @owner.repositories.build

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @repository }
    end
  end

  # GET /repositories/1/edit
  def edit
    @repository = @owner.repositories.by_param params[:id]
  end

  # POST /repositories
  # POST /repositories.xml
  def create
    @repository = @owner.repositories.build params[:repository]

    respond_to do |format|
      if @repository.save
        format.html { redirect_to([@owner, @repository], :notice => 'Repository was successfully created.') }
        format.xml  { render :xml => @repository, :status => :created, :location => @repository }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @repository.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /repositories/1
  # PUT /repositories/1.xml
  def update
    @repository = @owner.repositories.by_param params[:id]

    respond_to do |format|
      if @repository.update_attributes(params[:repository])
        format.html { redirect_to([@owner, @repository], :notice => 'Repository was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @repository.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /repositories/1
  # DELETE /repositories/1.xml
  def destroy
    @repository = @owner.repositories.by_param params[:id]
    @repository.destroy

    respond_to do |format|
      format.html { redirect_to(polymorphic_path([@owner, :repositories])) }
      format.xml  { head :ok }
    end
  end

private
  # Find the owner whether it is a project or user
  def get_owner
    if params[:user_id]
      @owner = User.by_param params[:user_id]
    elsif params[:project_id]
      @owner = Project.by_param params[:project_id]
    else
      raise UnknownRepositoryOwner
    end
  end
end

class UnknownRepositoryOwner < Exception; end
