require File.dirname(__FILE__) + '/../test_helper'

class VisitsSummaryTest < ActiveSupport::TestCase
  def test_days_summary
    create_visits_fixture

    report = VisitsSummary.new(:organization_id => organizations(:sfbk).id, :from => Date.new(2006,4,1), :to => Date.new(2006,4,2))
    assert_equal Date.new(2006,4,1), report.criteria[:from]
    assert_equal Date.new(2006,4,2), report.criteria[:to]
    assert_not_nil report.days
    assert_equal 1, report.days.size
    assert_equal Date.new(2006,4,1), report.days.first.date
    assert_equal 1, report.days.first.staff
    assert_equal 3, report.days.first.volunteer
    assert_equal 3, report.days.first.member
    assert_equal 4, report.days.first.patron
    assert_equal 11, report.days.first.total
  end

  def test_to_csv
    create_visits_fixture

    report = VisitsSummary.new(:organization_id => organizations(:sfbk).id, :from => Date.new(2006,4,1), :to => Date.new(2006,4,2))
  end

  def create_visits_fixture
    Visit.create!(:person => people(:marty), :datetime => TzTime.local(2006,4,1,18,30), :volunteer => true)
    Visit.create!(:person => people(:marty), :datetime => TzTime.local(2006,4,1,18,30), :volunteer => false) # count as member
    2.times do
      Visit.create!(:person => people(:mary), :datetime => TzTime.local(2006,4,1,18,30))
    end
    3.times do
      Visit.create!(:person => people(:mary), :datetime => TzTime.local(2006,4,1,18,30), :volunteer => true)
    end
    4.times do
      Visit.create!(:person => people(:daryl), :datetime => TzTime.local(2006,4,1,18,30))
    end
  end
end
