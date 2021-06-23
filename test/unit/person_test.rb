# encoding: utf-8

require 'test_helper'

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

  def test_saves_name_with_international_chars
    person = Person.create! :organization => organizations(:sfbk), :first_name => 'Erik', :last_name => 'Dölerud'
    assert_equal person.full_name, 'Erik Dölerud'
    assert_equal person.last_name, 'Dölerud'
  end

  def test_titleize_name
    assert_equal 'First Last', Person.create!(:organization => organizations(:sfbk), :first_name => 'first', :last_name => 'last').full_name
    assert_equal 'First de Last', Person.create!(:organization => organizations(:sfbk), :first_name => 'first', :last_name => 'de last').full_name
    assert_equal 'Erik Dölerud', Person.create!(:organization => organizations(:sfbk), :first_name => 'erik', :last_name => 'dölerud').full_name
    assert_equal 'First McLast', Person.create!(:organization => organizations(:sfbk), :first_name => 'First', :last_name => 'McLast').full_name
  end

  def test_validates_yob
    assert Person.create(:organization => organizations(:sfbk), :first_name => "first").errors.empty?
    assert Person.create(:organization => organizations(:sfbk), :first_name => "first", :yob => 1972).errors.empty?
    assert !Person.create(:organization => organizations(:sfbk), :first_name => "first", :yob => Date.today.year + 1).errors.empty?
    assert !Person.create(:organization => organizations(:sfbk), :first_name => "first", :yob => "foo").errors.empty?
    assert !Person.create(:organization => organizations(:sfbk), :first_name => "first", :yob => Date.today.year - 100).errors.empty?
  end

  def test_titleize_address
    person = Person.create!(:organization => organizations(:sfbk), :first_name => "first",
                            :street1 => "street1 st.", :street2 => "street2 st.",
                            :city => "city", :state => "st");
    assert_equal "Street1 St.", person.street1
    assert_equal "Street2 St.", person.street2
    assert_equal "City", person.city
    assert_equal "ST", person.state

    person.update_attributes!(:state => 'State')
    assert_equal "State", person.state
  end

  def test_visits_order
    assert_equal visits(:mary_2), people(:mary).visits[0]
    assert_equal visits(:mary_1), people(:mary).visits[1]
  end

  def test_matching_name
    assert_equal 3, Person.matching_name('ma').size
    assert_equal 2, Person.for_organization(organizations(:sfbk)).matching_name('ma').size
  end

  def test_matching_email
    assert_equal 2, Person.matching_email('ma').size
    assert_equal 1, Person.matching_email('mary@example.com').size
  end

  def test_in_date_range
    from, to = Date.new(2007,1,1), Date.new(2008,1,3)
    assert_equal 8, Person.after(from).size
    assert_equal 2, Person.after(from).before(to).size
  end

  def test_is_staff
    assert_equal 2, Person.is_staff(true).size
    Person.is_staff(true).each do |person| 
      assert person.staff
    end
    assert_equal 6, Person.is_staff(false).size
    Person.is_staff(false).each do |person| 
      assert !person.staff
    end
  end

  def test_email_validation
    assert Person.create(:organization => organizations(:sfbk), :email => 'mary@example.com').errors.invalid?(:email)
    assert Person.create(:organization => organizations(:sfbk), :email => 'mary@example').errors.invalid?(:email)
    assert !Person.create(:organization => organizations(:sfbk), :email => 'mary@foo.com').errors.invalid?(:email)
    assert !Person.create(:organization => organizations(:sfbk), :email => ' mary@foo.com').errors.invalid?(:email)
  end

  def test_membership
    assert_not_nil people(:mary).services.last(:membership)
    assert people(:mary).services.last(:membership).current?
    assert people(:mary).member?

    assert_not_nil people(:carrie).services.last(:membership)
    assert !people(:carrie).services.last(:membership).current?
    assert !people(:carrie).member?
  end

  def test_membership_on
    assert_not_nil people(:mary).services.on(:membership, Time.zone.local(2006,4,1))
    assert_not_nil people(:mary).membership_on(Time.zone.local(2006,4,1))
    assert people(:mary).member_on?(Time.zone.local(2006,4,1))

    assert_nil people(:mary).services.on(:membership, Time.zone.local(2000,4,1))
    assert_nil people(:mary).membership_on(Time.zone.local(2000,4,1))
    assert !people(:mary).member_on?(Time.zone.local(2000,4,1))
  end

  def test_csv_header
    assert_equal "id,first_name,last_name,staff,email,email_opt_out,phone,postal_code,street1,street2,city,state,postal_code,country,yob,tag_list,created_at,membership_expires_on\n", Person.csv_header
  end

  def test_to_csv
    assert_match /^\d+,Mary,Member,false,mary@example.com,false,415 123-1234,95105,123 Street St,,San Francisco,CA,95105,USA,1972,"mechanic, mom",2008-01-02 07:00,\d{4}-\d{2}-\d{2}$/, people(:mary).to_csv
  end

  context "A person Mary with tags" do
    setup do
      @person = people(:mary)
      assert_equal %w(mechanic mom), @person.tag_list
    end

    should "save comma-separated tags" do
      @person.tag_list = "helpful, Artist"
      @person.save! && @person.reload
      assert_equal %w[Artist helpful], @person.tag_list
    end

    should "add tag and sort tags" do
      @person.tag_list << 'keyholder'
      @person.save! && @person.reload

      assert_equal %w[keyholder mechanic mom], @person.tag_list
    end

    should "not add same tag with different case" do
      @person.tag_list << 'Mom'
      @person.save! && @person.reload

      assert_equal %w[mechanic mom], @person.tag_list
    end

    should "be found by tag" do
      people = Person.tagged_with 'mom'
      assert_equal 1, people.size
      assert_equal @person, people.first
    end
  end
end

