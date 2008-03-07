require File.dirname(__FILE__) + '/../test_helper'
require 'people_controller'

# Re-raise errors caught by the controller.
class PeopleController; def rescue_action(e) raise e end; end

class PeopleControllerTest < Test::Unit::TestCase
  fixtures :organizations, :people

  def setup
    @controller = PeopleController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    login_as 'greeter'
  end

  def test_should_get_index
    get :index, :organization_key => 'sfbk'
    assert_response :success
    assert_not_nil assigns(:people)
    assert_equal 4, assigns(:people).size
  end

  def test_should_get_new
    get :new, :organization_key => 'sfbk'
    assert_response :success
  end

  def test_should_create_person
    assert_difference('Person.count') do
      post :create, :organization_key => 'sfbk', :person => { :first_name => "Newbie" }
    end

    assert_equal organizations(:sfbk), assigns(:person).organization

    assert_redirected_to person_path(:organization_key => 'sfbk', :id => assigns(:person))
  end

  def test_should_show_person
    get :show, :organization_key => 'sfbk', :id => people(:mary).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :organization_key => 'sfbk', :id => people(:mary).id
    assert_response :success
  end

  def test_should_update_person
    put :update, :organization_key => 'sfbk', :id => people(:mary).id, :person => { }

    assert_equal organizations(:sfbk), assigns(:person).organization
    
    assert_redirected_to person_path(:organization_key => 'sfbk', :id => assigns(:person))
  end

  def test_should_destroy_person
    assert_difference('Person.count', -1) do
      delete :destroy, :organization_key => 'sfbk', :id => people(:mary).id
    end

    assert_redirected_to people_path
  end

  def test_requires_manager
    login_as 'scbc'
    get :show, :organization_key => 'sfbk', :id => people(:mary).id

    assert_redirected_to new_session_path
  end

  def test_auto_complete
    get :auto_complete_for_person_full_name, :organization_key => 'sfbk', :person => { :full_name => 'memb' }
    assert_response :success
    assert_not_nil assigns(:items)
    assert_equal 1, assigns(:items).size
  end
end
