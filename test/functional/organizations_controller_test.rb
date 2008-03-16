require File.dirname(__FILE__) + '/../test_helper'
require 'organizations_controller'

# Re-raise errors caught by the controller.
class OrganizationsController; def rescue_action(e) raise e end; end

class OrganizationsControllerTest < Test::Unit::TestCase
  fixtures :users, :roles, :organizations

  def setup
    @controller = OrganizationsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end
      
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:organizations)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_organization
    assert_difference('Organization.count') do
      post :create, :organization => { :name => 'Davis Bike Church', :key => 'dbc'}
    end

    assert_equal 'Pacific', assigns(:organization).timezone

    assert_redirected_to organization_path(assigns(:organization))
  end

  def test_should_show_organization
    get :show, :id => organizations(:sfbk)
    assert_response :success
  end

  def test_should_show_organization_by_key
    get :show, :organization_key => 'sfbk'
    assert_response :success
  end

  def test_should_get_edit
    login_as 'sfbk'
    get :edit, :id => organizations(:sfbk)
    assert_response :success
  end

  def test_should_update_organization
    login_as 'sfbk'
    put :update, :id => organizations(:sfbk), :organization => { }
    assert_redirected_to organization_path(assigns(:organization))
  end

  def test_should_destroy_organization
    login_as 'admin'
    assert_difference('Organization.count', -1) do
      delete :destroy, :id => organizations(:sfbk)
    end

    assert_redirected_to organizations_path
  end

  def test_authorization
    login_as 'scbc'
    [:index, :new, :show].each do |action|
      get action, :id => organizations(:sfbk)
      assert_response :success
    end
    [:edit].each do |action|
      get action, :id => organizations(:sfbk)
      assert_redirected_to new_session_path
    end
  end
end
