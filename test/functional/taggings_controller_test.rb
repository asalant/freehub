require 'test_helper'

class TaggingsControllerTest < ActionController::TestCase
  context 'A person with tags' do
    setup do
      login_as 'greeter'
    end

    context 'after deleting a tag' do
      setup do
        delete :destroy, :organization_key => 'sfbk', :person_id => people(:mary), :id => 'mechanic'
        people(:mary).reload
      end

      should_redirect_to 'show person' do
        person_path(:organization_key => 'sfbk', :id => people(:mary))
      end

      should 'not have the deleted tag' do
        assert_equal ['mom'], people(:mary).tag_list
      end
    end

    context 'after adding a tag' do
      setup do
        put :create, :organization_key => 'sfbk', :person_id => people(:mary), :id => 'three'
        people(:mary).reload
      end

      should_redirect_to 'show person' do
        person_path(:organization_key => 'sfbk', :id => people(:mary))
      end

      should 'have the new tag' do
        assert_equal ['mechanic', 'mom', 'three'], people(:mary).tag_list
      end
    end
  end
end
