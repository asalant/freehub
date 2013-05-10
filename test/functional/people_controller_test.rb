require 'test_helper'

class PeopleControllerTest < ActionController::TestCase

  def setup
    super
    login_as 'greeter'
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

  def test_should_create_membership_too
    assert_difference('Person.count') do
      post :create, :organization_key => 'sfbk', :person => { :first_name => "Newbie" }, :membership => 'true'
    end
    assert_not_nil assigns(:person).membership
    assert assigns(:person).membership.current?
    assert assigns(:person).membership.paid?
    assert !assigns(:person).membership.volunteered?
  end

  def test_should_create_eab_too
    assert_difference('Person.count') do
          post :create, :organization_key => 'sfbk', :person => { :first_name => "Newbie" }, :eab => 'true'
    end
    assert_not_nil assigns(:person).services.last(:eab)
    assert assigns(:person).services.last(:eab).current?
  end

  def test_should_create_visit_too
    assert_difference('Person.count') do
          post :create, :organization_key => 'sfbk', :person => { :first_name => "Newbie" }, :visiting => 'true'
    end
    assert_equal 1, assigns(:person).visits.size
    assert_equal Date.today, assigns(:person).visits.first.arrived_at.to_date

    assert_redirected_to today_visits_path
  end

  def test_should_get_edit
    get :edit, :organization_key => 'sfbk', :id => people(:mary).id
    assert_response :success
  end

  def test_should_destroy_person
    assert_difference('Person.count', -1) do
      delete :destroy, :organization_key => 'sfbk', :id => people(:mary).id
    end

    assert_redirected_to '/sfbk'
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

  context "Update person" do

    setup do
      put :update, :organization_key => 'sfbk', :id => people(:mary),
          :person => { :tag_list => 'tag1, tag 2' }
    end

    should_redirect_to 'show person' do
      person_path(:organization_key => 'sfbk', :id => people(:mary))
    end

    should "create tags" do
      assert_equal ['tag 2', 'tag1'], assigns(:person).tag_list
    end

  end

  context "Show person" do
    setup do
      get :show, :organization_key => 'sfbk', :id => people(:mary).id
    end

    should respond_with :success
    should assign_to :person
    should assign_to :all_tags

    should 'render links to tags' do
      assert_select '.tags_control' do
        assert_select "a[href=/sfbk/tags/#{tags(:mom).id}]"
        assert_select "a[href=/sfbk/tags/#{tags(:mechanic).id}]"
      end
    end
  end
end
