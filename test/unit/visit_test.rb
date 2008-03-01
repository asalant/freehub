require File.dirname(__FILE__) + '/../test_helper'

class VisitTest < ActiveSupport::TestCase

  def test_for_person
    assert_equal 2, Visit.for_person(people(:mary)).size
    assert_equal visits(:mary_2), Visit.for_person(people(:mary))[0]
    assert_equal visits(:mary_1), Visit.for_person(people(:mary))[1]
  end

  def test_for_person_paged
    assert_equal 100, Visit.for_person(people(:daryl)).size
    assert_equal 100, Visit.for_person(people(:daryl)).paginate(:current => 2, :size => 20).size
  end

  def test_for_organization_paged
    assert_equal 102, Visit.for_organization(organizations(:sfbk)).paginate.size
    assert_equal 20, Visit.for_organization(organizations(:sfbk)).paginate.to_a.size
    assert_equal 102, Visit.for_organization(organizations(:sfbk)).paginate(:current => 2, :size => 10).size
    assert_equal 10, Visit.for_organization(organizations(:sfbk)).paginate(:current => 2, :size => 10).to_a.size
  end

  def test_for_organization_in_date_range
    from, to = Date.new(2008,2,1), Date.new(2008,2,3)
    assert_equal 98, Visit.for_organization(organizations(:sfbk)).before(from).size
    assert_equal 4, Visit.for_organization(organizations(:sfbk)).after(from).before(to).size
  end

  def test_paginated_association
    assert_equal 20, people(:daryl).visits.paginate.to_a.size
    assert_equal 4, people(:daryl).visits.paginate(:size => 4).to_a.size
  end

  def test_chain_finders
    finder_chain = { :for_organization => organizations(:sfbk),
                     :after => Date.new(2008,2,1),
                     :before => Date.new(2008,2,3) }

    assert_equal 4, Visit.chain_finders(finder_chain).paginate.size
  end

  def test_to_csv
    assert_equal 'Mary,Member,mary@example.com,,,Fri Feb 01 18:01:00 -0800 2008,', visits(:mary_1).to_csv
  end
end
