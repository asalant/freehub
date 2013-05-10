require 'test_helper'

class TagsControllerTest < ActionController::TestCase
  context "Tag" do
    setup do
      login_as 'greeter'

      people(:mary).save!
    end

    context "show" do
      setup do
        get :show, :organization_key => 'sfbk', :id => tags(:mom).id
      end

      should respond_with :success
      should render_template :show
      should assign_to :tag
      should assign_to :people

      should 'find matching people' do
        assert_equal 1, assigns(:people).size
        assert_equal people(:mary), assigns(:people).first
      end
    end
  end
end
