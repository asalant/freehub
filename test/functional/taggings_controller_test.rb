require 'test_helper'

class TaggingsControllerTest < ActionController::TestCase
  context 'A person with tags' do
    setup do
      login_as 'greeter'
      
      @person = people(:mary).tap do |p|
        p.tag_list = 'one, two'
        p.save!
      end
    end

    context 'when deleting a tag' do
      setup do
        delete :destroy, :organization_key => 'sfbk', :person_id => @person, :id => 'one'
        @person.reload
      end

      should_redirect_to 'show person' do
        person_path(:organization_key => 'sfbk', :id => @person)
      end

      should 'not have the deleted tag' do
        assert_equal ['two'], @person.tag_list
      end
    end
  end
end
