require File.dirname(__FILE__) + '/../test_helper'
require 'notes_controller'

# Re-raise errors caught by the controller.
class NotesController; def rescue_action(e) raise e end; end

class NotesControllerTest < Test::Unit::TestCase
  fixtures :visits, :notes

  def setup
    @controller = NotesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    login_as 'sfbk'
  end

  def test_should_get_index
    get :index, :organization_key => 'sfbk', :person_id => people(:mary)
    assert_response :success
    assert_not_nil assigns(:notes)
    assert_equal 4, assigns(:notes).size
  end

  def test_should_get_new
    get :new, :organization_key => 'sfbk', :person_id => people(:mary)
    assert_response :success
  end

  def test_should_create_note
    assert_difference('Note.count') do
      post :create, :organization_key => 'sfbk', :person_id => people(:mary), :note => { :text => 'New note'}
    end

    assert_redirected_to notes_path
  end

  def test_should_show_note
    get :show, :organization_key => 'sfbk', :person_id => people(:mary), :id => notes(:mary_visit_1)
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :organization_key => 'sfbk', :person_id => people(:mary), :id => notes(:mary_visit_1)
    assert_response :success
  end

  def test_should_update_note
    put :update, :organization_key => 'sfbk', :person_id => people(:mary), :id => notes(:mary_visit_1), :note => { }
    assert_redirected_to note_path(:id => assigns(:note))
  end

  def test_should_destroy_note
    assert_difference('Note.count', -1) do
      delete :destroy, :organization_key => 'sfbk', :person_id => people(:mary), :id => notes(:mary_visit_1)
    end

    assert_redirected_to notes_path
  end
end
