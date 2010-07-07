require 'test_helper'

class RepositoriesControllerTest < ActionController::TestCase
  setup do
    @repository = repositories(:one)
    @new_attributes = { :name => 'new repository', :project_id => 1, :scm => 1 }
    @project = projects(:one)
  end

  test "should get index" do
    get :index, :project_id => @project.to_param
    assert_response :success
    assert_not_nil assigns(:repositories)
  end

  test "should get new" do
    get :new, :project_id => @project.to_param
    assert_response :success
  end

  test "should create repository" do
    assert_difference('Repository.count') do
      post :create, :repository => @new_attributes, :project_id => @project.to_param
    end

    assert_redirected_to project_repository_path(@project, assigns(:repository))
  end

  test "should show repository" do
    get :show, :id => @repository.to_param, :project_id => @project.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @repository.to_param, :project_id => @project.to_param
    assert_response :success
  end

  test "should update repository" do
    put :update, :id => @repository.to_param, :repository => @repository.attributes, :project_id => @project.to_param
    assert_redirected_to project_repository_path(@project, assigns(:repository))
  end

  test "should destroy repository" do
    assert_difference('Repository.count', -1) do
      delete :destroy, :id => @repository.to_param, :project_id => @project.to_param
    end

    assert_redirected_to project_repositories_path(@project)
  end
end
