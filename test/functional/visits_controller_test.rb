require File.dirname(__FILE__) + '/../test_helper'
require 'visits_controller'

# Re-raise errors caught by the controller.
class VisitsController; def rescue_action(e) raise e end; end

class VisitsControllerTest < Test::Unit::TestCase
  fixtures :organizations, :people, :visits

  def setup
    @controller = VisitsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    login_as 'greeter'
  end

  def test_should_get_index_for_person
    get :index, :organization_key => 'sfbk', :person_id => people(:mary)
    assert_response :success
    assert_not_nil assigns(:visits)
    assert_equal 2, assigns(:visits).size
  end

  def test_should_get_index_for_person_paged
    get :index, :organization_key => 'sfbk', :person_id => people(:daryl), :page => 2
    assert_response :success
    assert_not_nil assigns(:visits)
    assert_equal 100, assigns(:visits).size
    assert_equal 2, assigns(:visits).page
  end

  def test_should_get_new
    get :new, :organization_key => 'sfbk', :person_id => people(:mary)
    assert_response :success
  end

  def test_should_create_visit
    assert_difference('Visit.count') do
      post :create, :organization_key => 'sfbk', :person_id => people(:mary), :visit => { }
    end
    assert_equal people(:mary), assigns(:visit).person

    assert_redirected_to visits_path
  end

  def test_should_show_visit
    get :show, :organization_key => 'sfbk', :person_id => people(:mary), :id => visits(:mary_1).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :organization_key => 'sfbk', :person_id => people(:mary), :id => visits(:mary_1).id
    assert_response :success
  end

  def test_should_update_visit
    put :update, :organization_key => 'sfbk', :person_id => people(:mary), :id => visits(:mary_1).id, :visit => { }
    assert_redirected_to visit_path(:id => assigns(:visit))
  end

  def test_should_destroy_visit
    assert_difference('Visit.count', -1) do
      delete :destroy, :organization_key => 'sfbk', :person_id => people(:mary), :id => visits(:mary_1).id
    end

    assert_redirected_to visits_path
  end
end
