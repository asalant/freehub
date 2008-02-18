require File.dirname(__FILE__) + '/../test_helper'

class PeopleControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index, :organization_key => 'sfbk'
    assert_response :success
    assert_not_nil assigns(:people)
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

    assert_equal organizations(:sfbk), assigns(:person).reload.organization
    
    assert_redirected_to person_path(:organization_key => 'sfbk', :id => assigns(:person))
  end

  def test_should_destroy_person
    assert_difference('Person.count', -1) do
      delete :destroy, :organization_key => 'sfbk', :id => people(:mary).id
    end

    assert_redirected_to people_path
  end
end
