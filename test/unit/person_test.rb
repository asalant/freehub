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

  def test_matching_name
    assert_equal 3, Person.matching_name('ma').size
    assert_equal 2, Person.for_organization(organizations(:sfbk)).matching_name('ma').size
  end

  def test_in_date_range
    from, to = Date.new(2007,1,1), Date.new(2008,1,3)
    assert_equal 6, Person.after(from).size
    assert_equal 2, Person.after(from).before(to).size
  end

  def test_email_validation
    assert Person.create(:organization => organizations(:sfbk), :email => 'mary@example.com').errors.invalid?(:email)
    assert Person.create(:organization => organizations(:sfbk), :email => 'mary@example').errors.invalid?(:email)
    assert !Person.create(:organization => organizations(:sfbk), :email => 'mary@foo.com').errors.invalid?(:email)
  end

  def test_membership
    assert_not_nil people(:mary).services.last(:membership)
    assert people(:mary).services.last(:membership).current?

    assert_not_nil people(:carrie).services.last(:membership)
    assert !people(:carrie).services.last(:membership).current?
  end

  def test_csv_header
    assert_equal 'first_name,last_name,staff,email,phone,postal_code,street1,street2,city,state,postal_code,country,created_at', Person.csv_header
  end

  def test_to_csv
    assert_match /^Mary,Member,false,mary@example.com,415 123-1234,95105,123 Street St,,San Francisco,CA,95105,USA,2008-01-02 00:00:00/, people(:mary).to_csv
  end
end
