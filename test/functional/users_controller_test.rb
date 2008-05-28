require File.dirname(__FILE__) + '/../test_helper'
require 'users_controller'

# Re-raise errors caught by the controller.
class UsersController; def rescue_action(e) raise e end; end

class UsersControllerTest < Test::Unit::TestCase
  fixtures :users

  def setup
    @controller = UsersController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_allow_signup
    assert_difference 'User.count' do
      create_user
      assert assigns(:user)
      assert_redirected_to user_path(assigns(:user))
    end
  end

  def test_should_require_login_on_signup
    assert_no_difference 'User.count' do
      create_user(:login => nil)
      assert assigns(:user).errors.on(:login)
      assert_response :success
    end
  end

  def test_should_require_password_on_signup
    assert_no_difference 'User.count' do
      create_user(:password => nil)
      assert assigns(:user).errors.on(:password)
      assert_response :success
    end
  end

  def test_should_require_password_confirmation_on_signup
    assert_no_difference 'User.count' do
      create_user(:password_confirmation => nil)
      assert assigns(:user).errors.on(:password_confirmation)
      assert_response :success
    end
  end

  def test_should_require_email_on_signup
    assert_no_difference 'User.count' do
      create_user(:email => nil)
      assert assigns(:user).errors.on(:email)
      assert_response :success
    end
  end
  
  def test_should_activate_user
    assert_nil User.authenticate('mechanic', 'test')
    get :activate, :activation_code => users(:mechanic).activation_code
    assert_redirected_to '/sfbk'
    assert_not_nil flash[:notice]
    assert_equal users(:mechanic), User.authenticate('mechanic', 'test')
  end
  
  def test_should_not_activate_user_without_key
    get :activate
    assert_nil flash[:notice]
  rescue ActionController::RoutingError
    # in the event your routes deny this, we'll just bow out gracefully.
  end

  def test_should_not_activate_user_with_blank_key
    get :activate, :activation_code => ''
    assert_nil flash[:notice]
  rescue ActionController::RoutingError
    # well played, sir
  end

  def test_should_show_forgot
    get :forgot
    assert_response :success
  end

  def test_should_show_forget_for_nonexisting_user
    post :forgot, :user => { :email => 'foo@bar.com' }
    assert_response :success
    assert_equal 'foo@bar.com does not exist in system', @response.flash[:notice]
  end

  def test_should_send_reset_code_for_known_user
    post :forgot, :user => { :email => 'sfbk@example.com' }
    assert_redirected_to new_session_path
  end

  def test_should_show_reset
    users(:sfbk).create_reset_code
    get :reset, :reset_code => users(:sfbk).reset_code
    assert_response :success
  end

  def test_should_not_reset_with_errors
    users(:sfbk).create_reset_code
    post :reset, :reset_code => users(:sfbk).reset_code, :user => { :password => '' , :password_confirmation => '' }
    assert_response :success
    assert !assigns(:user).errors.empty?
  end

  def test_should_reset_password
    users(:sfbk).create_reset_code
    post :reset, :reset_code => users(:sfbk).reset_code, :user => { :password => 'new_password' , :password_confirmation => 'new_password' }
    assert_redirected_to user_path(:id => users(:sfbk))
    assert User.authenticate('sfbk', 'new_password')
  end

  def test_should_get_index
    login_as :admin
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_show_user
    login_as :sfbk
    get :show, :id => users(:greeter)
    assert_response :success
    assert assigns(:user)
    assert assigns(:organization)
    assert_equal organizations(:sfbk), assigns(:organization)
  end

  def test_should_get_edit
    login_as :sfbk
    get :edit, :id => users(:sfbk)
    assert_response :success
    assert assigns(:user)
    assert assigns(:organization)
  end

  def test_should_update_user
    login_as :greeter
    put :update, :id => users(:greeter), :user => { }
    assert_redirected_to user_path(assigns(:user))
  end

  def test_should_destroy_user
    login_as :admin
    assert_difference('User.count', -1) do
      delete :destroy, :id => users(:greeter)
    end

    assert_redirected_to users_path
  end


  protected
    def create_user(options = {})
      post :create, :user => { :name => 'Quire', :login => 'quire', :email => 'quire@example.com',
        :password => 'quire', :password_confirmation => 'quire' }.merge(options)
    end
end
