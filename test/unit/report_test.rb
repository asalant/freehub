require File.dirname(__FILE__) + '/../test_helper'

class ReportTest < ActiveSupport::TestCase
  def test_summary

    Visit.create!(:person => people(:marty), :datetime => TzTime.local(2006,4,1,6,30))
    2.times do
      Visit.create!(:person => people(:mary), :datetime => TzTime.local(2006,4,1,6,30))
    end
    3.times do
      Visit.create!(:person => people(:mary), :datetime => TzTime.local(2006,4,1,6,30), :volunteer => true)
    end
    4.times do
      Visit.create!(:person => people(:daryl), :datetime => TzTime.local(2006,4,1,6,30))
    end

    report = Report.summary(:organization_id => organizations(:sfbk).id, :from => Date.new(2006,4,1), :to => Date.new(2006,4,2))
    assert_equal Date.new(2006,4,1), report.criteria[:from]
    assert_equal Date.new(2006,4,2), report.criteria[:to]
    assert_not_nil report.result[:visits]
    assert_equal 1, report.result[:visits].size
    assert_equal Date.new(2006,4,1), report.result[:visits].first[:date]
    assert_equal 1, report.result[:visits].first[:staff]
    assert_equal 3, report.result[:visits].first[:volunteer]
    assert_equal 2, report.result[:visits].first[:member]
    assert_equal 4, report.result[:visits].first[:patron]
    #assert_equal 10, report.result[:visits].first[:total]
  end
end
