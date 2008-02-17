require File.dirname(__FILE__) + '/../test_helper'

class ShopsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:shops)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_shop
    assert_difference('Shop.count') do
      post :create, :shop => { }
    end

    assert_redirected_to shop_path(assigns(:shop))
  end

  def test_should_show_shop
    get :show, :id => shops(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => shops(:one).id
    assert_response :success
  end

  def test_should_update_shop
    put :update, :id => shops(:one).id, :shop => { }
    assert_redirected_to shop_path(assigns(:shop))
  end

  def test_should_destroy_shop
    assert_difference('Shop.count', -1) do
      delete :destroy, :id => shops(:one).id
    end

    assert_redirected_to shops_path
  end
end
