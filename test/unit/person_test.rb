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

  def test_full_name_update
    person = Person.create! :organization => organizations(:sfbk), :first_name => 'First', :last_name => 'Last'
    assert_equal person.full_name, 'First Last'
    person.update_attributes!(:last_name => '')
    assert_equal 'First', person.full_name
  end

  def test_visits_order
    assert_equal visits(:mary_2), people(:mary).visits[0]
    assert_equal visits(:mary_1), people(:mary).visits[1]
  end

  def test_for_organization_matching_name
    people = Person.for_organization_matching_name(organizations(:sfbk), 'ma')
    assert_equal 1, people.size
  end
end
