require 'test_helper'

class TagsControllerTest < ActionController::TestCase
  context "Tag" do
    setup do
      login_as 'greeter'

      people(:mary).tag_list = 'greeter'
      people(:mary).save!
    end

    context "show" do
      setup do
        get :show, :organization_key => 'sfbk', :id => 'greeter'
      end

      should_respond_with :success
      should_render_template :show
      should_assign_to :tag
      should_assign_to :people

      should 'find matching people' do
        assert_equal 1, assigns(:people).size
        assert_equal people(:mary), assigns(:people).first
      end
    end
  end
end
