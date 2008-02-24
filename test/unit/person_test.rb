require File.dirname(__FILE__) + '/../test_helper'

class PersonTest < ActiveSupport::TestCase

  def test_userstamps
    User.current_user = users(:greeter)

    person = Person.create! :organization => organizations(:sfbk), :first_name => 'Newbie'
    assert_not_nil person.created_by_id
    assert_not_nil person.updated_by_id
    assert_equal 'greeter', person.created_by.login
    assert_equal 'greeter', person.updated_by.login
  end
end
