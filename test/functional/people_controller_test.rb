require File.dirname(__FILE__) + '/../test_helper'

class PeopleControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:people)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_person
    assert_difference('Person.count') do
      post :create, :person => { :first_name => "Newbie", :organization => organizations(:sfbk)}
    end

    assert_equal organizations(:sfbk), assigns(:person).reload.organization

    assert_redirected_to person_path(assigns(:person))
  end

  def test_should_show_person
    get :show, :id => people(:mary).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => people(:mary).id
    assert_response :success
  end

  def test_should_update_person
    put :update, :id => people(:mary).id, :person => { }

    assert_equal organizations(:sfbk), assigns(:person).reload.organization
    
    assert_redirected_to person_path(assigns(:person))
  end

  def test_should_destroy_person
    assert_difference('Person.count', -1) do
      delete :destroy, :id => people(:mary).id
    end

    assert_redirected_to people_path
  end
end
