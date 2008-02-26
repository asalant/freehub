require File.dirname(__FILE__) + '/../test_helper'
require 'reports_Controller'

# Re-raise errors caught by the controller.
class ReportsController; def rescue_action(e) raise e end; end

class ReportsControllerTest < Test::Unit::TestCase
  fixtures :organizations, :people, :visits, :reports

  def setup
    @controller = ReportsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    login_as 'greeter'
  end

  def test_should_get_index
    get :index, :organization_key => 'sfbk'
    assert_response :success
    assert_not_nil assigns(:reports)
  end

  def test_should_get_new
    get :new, :organization_key => 'sfbk'
    assert_response :success
  end

  def test_should_create_report
    assert_difference('Report.count') do
      post :create, :organization_key => 'sfbk', :report => { }
    end

    assert_redirected_to report_path(:id => assigns(:report))
  end

  def test_should_show_report
    get :show, :organization_key => 'sfbk', :id => reports(:visit).id, :page => 2
    assert_response :success
    assert_not_nil assigns(:visits)
    assert_equal 102, assigns(:visits).size
    assert_equal 10, assigns(:visits).to_a.size
    assert_equal 2, assigns(:visits).page
  end


  def test_should_show_visits
    get :visits, :organization_key => 'sfbk', :page => 2
    assert_response :success
    assert_not_nil assigns(:report)
    assert_not_nil assigns(:visits)
    assert_equal 102, assigns(:visits).size
    assert_equal 10, assigns(:visits).to_a.size
    assert_equal 2, assigns(:visits).page
  end

  def test_should_get_edit
    get :edit, :organization_key => 'sfbk', :id => reports(:visit).id
    assert_response :success
  end

  def test_should_update_report
    put :update, :organization_key => 'sfbk', :id => reports(:visit).id, :report => { }
    assert_redirected_to report_path(:id => assigns(:report))
  end

  def test_should_destroy_report
    assert_difference('Report.count', -1) do
      delete :destroy, :organization_key => 'sfbk', :id => reports(:visit).id
    end

    assert_redirected_to reports_path
  end
end
