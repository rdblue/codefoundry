require 'test_helper'
require 'authlogic/test_case'

class ProjectsControllerTest < ActionController::TestCase
  include Authlogic::TestCase

  setup do
    @project = projects(:one)
    activate_authlogic
    UserSession.create(users(:one))
    @new_attributes = { :name => 'abc', :summary => 'another project' }
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:projects)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create project" do
    assert_difference('Project.count') do
      post :create, :project => @new_attributes
    end

    assert_redirected_to project_path(assigns(:project))
  end

  test "should show project" do
    get :show, :id => @project.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @project.to_param
    assert_response :success
  end

  test "should update project" do
    put :update, :id => @project.to_param, :project => @project.attributes
    assert_redirected_to project_path(assigns(:project))
  end

  test "should destroy project" do
    assert_difference('Project.count', -1) do
      delete :destroy, :id => @project.to_param
    end

    assert_redirected_to projects_path
  end
end
