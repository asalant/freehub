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
    get :show, :organization_key => 'sfbk', :id => reports(:visit), :page => 2, :size => 10
    assert_response :success
    assert_not_nil assigns(:visits)
    assert_equal 102, assigns(:visits).size
    assert_equal 10, assigns(:visits).to_a.size
    assert_equal 2, assigns(:visits).page
  end


  def test_should_show_visits
    get :visits, :organization_key => 'sfbk',
        :report => { :target => 'Visit', :date_from => Date.new(2007,1,1), :date_to => Date.new(2009,1,1) },
        :page => 2
    assert_response :success
    assert_not_nil assigns(:report)
    assert_not_nil assigns(:visits)
    assert_equal 102, assigns(:visits).size
    assert_equal 20, assigns(:visits).to_a.size
    assert_equal 2, assigns(:visits).page
  end

  def test_visits_csv
    get :visits, :organization_key => 'sfbk',
        :report => { :target => 'Visit', :date_from => Date.new(2007,1,1), :date_to => Date.new(2009,1,1) },
        :format => 'csv'
    assert_response :success
    assert_not_nil assigns(:visits)
    assert_equal 102, assigns(:visits).size

    output = StringIO.new
    output.binmode
    assert_nothing_raised { @response.body.call(@response, output) }
    lines = output.string.split("\n")
    assert_equal assigns(:visits).size + 1, lines.size
    assert_equal 'first_name,last_name,email,phone,postal_code,datetime,volunteered', lines[0]
  end

  def test_signin
    get :signin, :organization_key => 'sfbk', :year => 2008, :month => 2, :day => 1
    assert_response :success
    assert_not_nil assigns(:visits)
    assert_equal 3, assigns(:visits).size
    assert_equal Date.new(2008,2,1), assigns(:day)
  end

  def test_should_get_edit
    get :edit, :organization_key => 'sfbk', :id => reports(:visit)
    assert_response :success
  end

  def test_should_update_report
    put :update, :organization_key => 'sfbk', :id => reports(:visit), :report => { }
    assert_redirected_to report_path(:id => assigns(:report))
  end

  def test_should_destroy_report
    assert_difference('Report.count', -1) do
      delete :destroy, :organization_key => 'sfbk', :id => reports(:visit)
    end

    assert_redirected_to reports_path
  end
end
