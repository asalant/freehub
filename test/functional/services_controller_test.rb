require File.dirname(__FILE__) + '/../test_helper'
require 'services_controller'

# Re-raise errors caught by the controller.
class ServicesController; def rescue_action(e) raise e end; end

class ServicesControllerTest < Test::Unit::TestCase
  fixtures :users, :roles, :service_types, :organizations, :people, :services

  def setup
    @controller = ServicesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    login_as 'sfbk'
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:services)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_service
    assert_difference('Service.count') do
      post :create, :service => { }
    end

    assert_redirected_to service_path(assigns(:service))
  end

  def test_should_show_service
    get :show, :id => services(:mary_membership).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => services(:mary_membership).id
    assert_response :success
  end

  def test_should_update_service
    put :update, :id => services(:mary_membership).id, :service => { }
    assert_redirected_to service_path(assigns(:service))
  end

  def test_should_destroy_service
    assert_difference('Service.count', -1) do
      delete :destroy, :id => services(:mary_membership).id
    end

    assert_redirected_to services_path
  end
end
