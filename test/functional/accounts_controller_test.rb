require 'test_helper'
require 'authlogic/test_case'

class AccountsControllerTest < ActionController::TestCase
  include Authlogic::TestCase

  setup do
    @account = users(:one)
    activate_authlogic
    UserSession.create(users(:one))
  end

  test "should show account" do
    get :show
    assert_response :success
  end

  test "should get edit" do
    get :edit
    assert_response :success
  end

  test "should update account" do
    put :update, :account => @account.attributes
    assert_redirected_to account_path
  end

end
