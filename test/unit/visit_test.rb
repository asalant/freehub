require File.dirname(__FILE__) + '/../test_helper'

class VisitTest < ActiveSupport::TestCase

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
    assert_match /^Mary,Member,false,mary@example.com,false,415 123-1234,95105,2008-02-01 18:01:00,false,.+/, visits(:mary_1).to_csv
  end

  def test_csv_header
    assert_equal 'first_name,last_name,staff,email,email_opt_out,phone,postal_code,datetime,volunteer,note', Visit.csv_header
  end

  def test_create_defaults
    assert_equal Date.today, Visit.create!(:person => people(:mary)).datetime.to_date
    assert_equal Time.local(2008,1,1), Visit.create!(:person => people(:mary), :datetime => Time.local(2008,1,1)).datetime.time
  end

  def test_note_association
    visit = Visit.create!(:person => people(:mary), :note => Note.new(:text => "test"))
    assert !visit.note.new_record?
    assert_not_nil visit.note.created_at
    assert_equal people(:mary), visit.note.notable.person
  end

end
