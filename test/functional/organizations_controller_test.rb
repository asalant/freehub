require 'test_helper'

class OrganizationsControllerTest < ActionController::TestCase
      
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:organizations)
  end

  def test_should_get_new
    get :new
    assert_response :success
    assert_select "form#new_organization" do
      assert_select '.section.organization input', 3
      assert_select '.section.organization select', 1
      assert_select '.section.user input', 6
    end
  end

  def test_should_create_organization
    assert_difference('Organization.count') do
      post :create, :organization => { :name => 'Davis Bike Church', :key => 'dbc'},
                    :user => { :name => 'New User', :login => 'newuser', :email => 'newuser@example.com',
                               :password => 'password', :password_confirmation => 'password' }
    end

    assert assigns(:organization)
    assert assigns(:user)
    assert_equal assigns(:user).roles.first.authorizable, assigns(:organization)

    assert_redirected_to '/dbc'
  end

  def test_should_show_organization
    login_as 'sfbk'
    get :show, :id => organizations(:sfbk)
    assert_response :success
  end

  def test_should_show_organization_for_unactivated_user
    login_as 'mechanic'
    get :show, :id => organizations(:sfbk)
    assert_response :success
  end

  def test_should_show_organization_by_key
    login_as 'sfbk'
    get :show, :organization_key => 'sfbk'
    assert_response :success
  end

  def test_should_get_edit
    login_as 'sfbk'
    get :edit, :id => organizations(:sfbk)
    assert_response :success
    assert_select "form" do
      assert_select 'input', 5
    end
  end

  def test_should_update_organization
    login_as 'sfbk'
    put :update, :id => organizations(:sfbk), :organization => { }
    assert_redirected_to '/sfbk'
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
    [:index, :new].each do |action|
      get action, :id => organizations(:sfbk)
      assert_response :success
    end
    [:show, :edit].each do |action|
      get action, :id => organizations(:sfbk)
      assert_redirected_to new_session_path
    end
  end
end
