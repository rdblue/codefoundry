require 'test_helper'

class PrivilegesControllerTest < ActionController::TestCase
 
  # convenience method to get the project privileges, since privileges 
  # alone don't exist
  def privileges(arg)
    project_privileges(arg)
  end

  setup do
    @project = projects(:one)
    @privilege = privileges(:one)
  end

  test "should get index" do
    get :index, :project_id => @project.to_param
    assert_response :success
    assert_not_nil assigns(:privileges)
  end

  test "should get new" do
    get :new, :project_id => @project.to_param
    assert_response :success
  end

  test "should create privilege" do
    assert_difference('ProjectPrivilege.count') do
      post :create, :privilege => @privilege.attributes.merge({:role_id => 3 }), :project_id => @project.to_param
    end

    assert_redirected_to project_privileges_path(@project)
  end

  test "should show privilege" do
    get :show, :id => @privilege.to_param, :project_id => @project.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @privilege.to_param, :project_id => @project.to_param
    assert_response :success
  end

  test "should update privilege" do
    put :update, :id => @privilege.to_param, :privilege => @privilege.attributes, :project_id => @project.to_param
    assert_redirected_to project_privileges_path(@project)
  end

  test "should destroy privilege" do
    assert_difference('ProjectPrivilege.count', -1) do
      delete :destroy, :id => @privilege.to_param, :project_id => @project.to_param
    end

    assert_redirected_to project_privileges_path(@project)
  end
end
