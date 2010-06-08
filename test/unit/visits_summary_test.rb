require File.dirname(__FILE__) + '/../test_helper'

class VisitsSummaryTest < ActiveSupport::TestCase
  def test_days_summary
    create_fixtures

    report = VisitsSummary.new(:organization_id => organizations(:sfbk).id, :from => Date.new(2006,4,1), :to => Date.new(2006,4,6))
    assert_equal Date.new(2006,4,1), report.criteria[:from]
    assert_equal Date.new(2006,4,6), report.criteria[:to]
    assert_not_nil report.days
    assert_equal 5, report.days.size
    assert_equal Date.new(2006,4,1), report.days.first.date
    assert_equal 1, report.days.first.staff
    assert_equal 3, report.days.first.volunteer
    assert_equal 3, report.days.first.member
    assert_equal 4, report.days.first.patron
    assert_equal 11, report.days.first.total

    assert_equal 0, report.days.last.total
  end

  def test_weeks_summary
    create_fixtures

    report = VisitsSummary.new(:organization_id => organizations(:sfbk).id, :from => Date.new(2006,4,1), :to => Date.new(2006,4,4))

    assert_not_nil report.weeks
    assert_equal 2, report.weeks.size
    assert_equal 1, report.weeks.first.total_day.staff
    assert_equal 3, report.weeks.first.total_day.volunteer
    assert_equal 3, report.weeks.first.total_day.member
    assert_equal 4, report.weeks.first.total_day.patron
    assert_equal 11, report.weeks.first.total_day.total

    assert_equal 0, report.weeks.last.total_day.total
  end

  def create_fixtures
    Visit.create!(:person => people(:marty), :datetime => Time.zone.local(2006,4,1,18,30), :volunteer => true)
    Visit.create!(:person => people(:marty), :datetime => Time.zone.local(2006,4,1,18,30), :volunteer => false) # count as member
    2.times do
      Visit.create!(:person => people(:mary), :datetime => Time.zone.local(2006,4,1,18,30))
    end
    3.times do
      Visit.create!(:person => people(:mary), :datetime => Time.zone.local(2006,4,1,18,30), :volunteer => true)
    end
    4.times do
      Visit.create!(:person => people(:daryl), :datetime => Time.zone.local(2006,4,1,18,30))
    end
  end
end
