require File.dirname(__FILE__) + '/../test_helper'

class VisitTest < ActiveSupport::TestCase

  def test_find_by_person
    assert_equal 2, Visit.find_by_person(people(:mary)).size
    assert_equal visits(:mary_2), Visit.find_by_person(people(:mary)).to_a[0]
    assert_equal visits(:mary_1), Visit.find_by_person(people(:mary)).to_a[1]
  end

  def test_find_by_person_paged
    assert_equal 100, Visit.find_by_person(people(:daryl)).size
    assert_equal 100, Visit.find_by_person(people(:daryl), :current => 2, :size => 20).size
  end

  def test_find_by_organization_paged
    assert_equal 102, Visit.find_by_organization(organizations(:sfbk)).size
    assert_equal 102, Visit.find_by_organization(organizations(:sfbk), :current => 2, :size => 20).size
    assert_equal 20, Visit.find_by_organization(organizations(:sfbk), :current => 2, :size => 20).to_a.size
  end
end
