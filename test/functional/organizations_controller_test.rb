require File.dirname(__FILE__) + '/../test_helper'

class OrganizationsControllerTest < ActionController::TestCase
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
      post :create, :organization => { }
    end

    assert_redirected_to organization_path(assigns(:organization))
  end

  def test_should_show_organization
    get :show, :id => organizations(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => organizations(:one).id
    assert_response :success
  end

  def test_should_update_organization
    put :update, :id => organizations(:one).id, :organization => { }
    assert_redirected_to organization_path(assigns(:organization))
  end

  def test_should_destroy_organization
    assert_difference('Organization.count', -1) do
      delete :destroy, :id => organizations(:one).id
    end

    assert_redirected_to organizations_path
  end
end
