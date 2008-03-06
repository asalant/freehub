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
    login_as 'greeter'
  end

  def test_should_get_index
    get :index, :organization_key => 'sfbk', :person_id => people(:mary)
    assert_response :success
    assert_not_nil assigns(:services)
  end

  def test_should_get_new
    get :new, :organization_key => 'sfbk', :person_id => people(:mary)
    assert_response :success
  end

  def test_should_create_service
    assert_difference('Service.count') do
      post :create, :organization_key => 'sfbk', :person_id => people(:mary), :service => { :service_type_id => service_types(:class) }
    end

    assert_redirected_to services_path
  end

  def test_should_show_service
    get :show, :organization_key => 'sfbk', :person_id => people(:mary), :id => services(:mary_membership)
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :organization_key => 'sfbk', :person_id => people(:mary), :id => services(:mary_membership)
    assert_response :success
  end

  def test_should_update_service
    put :update, :organization_key => 'sfbk', :person_id => people(:mary), :id => services(:mary_membership), :service => { }
    assert_redirected_to service_path(:id => assigns(:service))
  end

  def test_should_destroy_service
    assert_difference('Service.count', -1) do
      delete :destroy, :organization_key => 'sfbk', :person_id => people(:mary), :id => services(:mary_membership)
    end

    assert_redirected_to services_path
  end
end
