require File.dirname(__FILE__) + '/../test_helper'
require 'organizations_controller'

# Re-raise errors caught by the controller.
class OrganizationsController; def rescue_action(e) raise e end; end

class OrganizationsControllerTest < Test::Unit::TestCase
  fixtures :organizations

  def setup
    @controller = OrganizationsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    login_as 'greeter'
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
      post :create, :organization => { :name => 'SFBK'}
    end

    assert_equal 'Pacific', assigns(:organization).timezone

    assert_redirected_to organization_path(assigns(:organization))
  end

  def test_should_show_organization
    get :show, :id => organizations(:sfbk).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => organizations(:sfbk).id
    assert_response :success
  end

  def test_should_update_organization
    put :update, :id => organizations(:sfbk).id, :organization => { }
    assert_redirected_to organization_path(assigns(:organization))
  end

  def test_should_destroy_organization
    assert_difference('Organization.count', -1) do
      delete :destroy, :id => organizations(:sfbk).id
    end

    assert_redirected_to organizations_path
  end
end
