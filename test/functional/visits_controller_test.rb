require 'test_helper'

class VisitsControllerTest < ActionController::TestCase

  def setup
    super
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
    assert_select 'form' do
      assert_select 'textarea', 1
    end
  end

  def test_should_create_visit
    assert_difference('Visit.count') do
      post :create, :organization_key => 'sfbk', :person_id => people(:mary), :visit => { }, :note => { :text => 'test' }
    end
    assert_equal people(:mary), assigns(:visit).person
    assert_equal 'test', assigns(:visit).note.text

    assert_redirected_to visits_url
  end

  def test_should_create_visit_in_eastern_timezone
    login_as :cbi
    assert_difference('Visit.count') do
      post :create, :organization_key => 'cbi', :person_id => people(:penny), :visit => { }
    end
    assert_equal people(:penny), assigns(:visit).person
    assert_equal "Eastern Time (US & Canada)", Time.zone.name
    assert_equal Time.zone.now.hour, assigns(:visit).datetime.hour

    assert_redirected_to visits_path
  end

  def test_should_create_visit_with_destination
    assert_difference('Visit.count') do
      post :create, :organization_key => 'sfbk', :person_id => people(:mary), :visit => { },
              :destination => "/sfbk/visits/#{Date.today.year}/#{Date.today.month}/#{Date.today.day}"
    end
    assert_equal people(:mary), assigns(:visit).person

    assert_redirected_to "/sfbk/visits/#{Date.today.year}/#{Date.today.month}/#{Date.today.day}"
  end

  def test_should_show_visit
    get :show, :organization_key => 'sfbk', :person_id => people(:mary), :id => visits(:mary_1)
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :organization_key => 'sfbk', :person_id => people(:mary), :id => visits(:mary_1)
    assert_response :success
    assert_select 'form' do
      assert_select 'textarea', 1
    end
  end

  def test_should_update_visit
    put :update, :organization_key => 'sfbk', :person_id => people(:mary), :id => visits(:mary_1), :visit => { }, :note => { :text => 'test' }
    assert_redirected_to visit_path(:id => assigns(:visit))
    assert_equal 'test', assigns(:visit).note.text
  end

  def test_should_update_visit_with_destination
    put :update, :organization_key => 'sfbk', :person_id => people(:mary), :id => visits(:mary_1), :visit => { }, :note => { :text => 'test' },
              :destination => "/sfbk/visits/2007/02/01"
    assert_redirected_to '/sfbk/visits/2007/02/01'
    assert_equal 'test', assigns(:visit).note.text
  end

  def test_should_destroy_visit
    assert_difference('Visit.count', -1) do
      delete :destroy, :organization_key => 'sfbk', :person_id => people(:mary), :id => visits(:mary_1)
    end

    assert_redirected_to visits_path
  end

  def test_should_destroy_visit_with_destination
    visit = visits(:mary_1)
    assert_difference('Visit.count', -1) do
      delete :destroy, :organization_key => 'sfbk', :person_id => people(:mary), :id => visit,
              :destination => "/sfbk/visits/2007/02/01"
    end

    assert_redirected_to '/sfbk/visits/2007/02/01'
  end

  def test_visits_for_day
    get :day, :organization_key => 'sfbk', :year => 2007, :month => 2, :day => 1
    assert_response :success
    assert_not_nil assigns(:visits)
    assert_equal 2, assigns(:visits).size
    assert_equal Date.new(2007,2,1), assigns(:day)
    assert_not_nil assigns(:groups)
    assert_equal 0, assigns(:groups)[:volunteers].size
    assert_equal 2, assigns(:groups)[:patrons].size
  end
end
