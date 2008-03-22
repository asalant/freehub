require File.dirname(__FILE__) + '/../test_helper'

class ServiceTest < ActiveSupport::TestCase

  def test_for_organization_paged
    assert_equal 64, Service.for_organization(organizations(:sfbk)).paginate.size
    assert_equal 20, Service.for_organization(organizations(:sfbk)).paginate.to_a.size
    assert_equal 64, Service.for_organization(organizations(:sfbk)).paginate(:current => 2, :size => 10).size
    assert_equal 10, Service.for_organization(organizations(:sfbk)).paginate(:current => 2, :size => 10).to_a.size
  end

  def test_for_organization_in_date_range
    from, to = Date.new(2007,8,1), Date.new(2008,2,3)
    assert_equal 55, Service.for_organization(organizations(:sfbk)).before(from).size
    assert_equal 19, Service.for_organization(organizations(:sfbk)).after(from).before(to).size
  end

  def test_for_service_types
    assert_equal 3, Service.for_service_types('MEMBERSHIP').size
    assert_equal 64, Service.for_service_types(['MEMBERSHIP', 'CLASS']).size
  end

  def test_current
    assert !Service.new(:start_date => Date.yesterday, :end_date => Date.yesterday).current?
    assert !Service.new(:start_date => Date.tomorrow, :end_date => Date.tomorrow).current?
    assert Service.new(:start_date => Date.yesterday, :end_date => Date.today).current?
    assert Service.new(:start_date => Date.today, :end_date => Date.tomorrow).current?
    assert Service.new(:start_date => Date.yesterday).current?
    assert Service.new(:end_date => Date.tomorrow).current?
  end

  def test_csv_header
    assert_equal 'first_name,last_name,email,email_opt_out,phone,postal_code,service_type_id,start_date,end_date,volunteered,paid,note', Service.csv_header
  end
  
  def test_to_csv
    assert_match /^Mary,Member,mary@example.com,false,415 123-1234,95105,MEMBERSHIP,\d{4}-\d{2}-\d{2},\d{4}-\d{2}-\d{2},false,true,/, services(:mary_membership).to_csv
  end

  def test_note_association
    service = Service.create!(:person => people(:mary), :service_type_id => 'MEMBERSHIP', :note => Note.new(:text => "test"))
    assert !service.note.new_record?
    assert_not_nil service.note.created_at
    assert_equal people(:mary), service.note.notable.person
  end

end
