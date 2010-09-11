module PrivilegesHelper
  PLURAL_ACTIONS = [:index, :create]
  
  # Generates the appropriate path for privilegable objects such as
  # projects and repositories:
  #
  # /projects/:project_id/privileges
  # /projects/:project_id/privileges/new
  # /projects/:project_id/privileges/1/edit
  # /projects/:project_id/repositories/:repository_id/privileges
  # ...
  def privilegable_path(action = :index, privilegable = nil)
    options = {}
    options[:action] = action if action and action != :index and action != :show
    suffix = :privilege
    suffix = :privileges if PLURAL_ACTIONS.include? action
    path_array = [@project]
    path_array.push(@repository) if @repository
 
    if privilegable
      path_array.push(privilegable) 
    else
      path_array.push(suffix)
    end

    polymorphic_path(path_array, options)
  end
end
