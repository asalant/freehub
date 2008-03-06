require File.dirname(__FILE__) + '/../test_helper'
require 'service_types_controller'

# Re-raise errors caught by the controller.
class ServiceTypesController; def rescue_action(e) raise e end; end

class ServiceTypesControllerTest < Test::Unit::TestCase
  fixtures :users, :roles, :service_types

  def setup
    @controller = ServiceTypesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    login_as 'admin'
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:service_types)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_service_type
    assert_difference('ServiceType.count') do
      post :create, :service_type => { }
    end

    assert_redirected_to service_type_path(assigns(:service_type))
  end

  def test_should_show_service_type
    get :show, :id => service_types(:membership).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => service_types(:membership).id
    assert_response :success
  end

  def test_should_update_service_type
    put :update, :id => service_types(:membership).id, :service_type => { }
    assert_redirected_to service_type_path(assigns(:service_type))
  end

  def test_should_destroy_service_type
    assert_difference('ServiceType.count', -1) do
      delete :destroy, :id => service_types(:membership).id
    end

    assert_redirected_to service_types_path
  end
end
