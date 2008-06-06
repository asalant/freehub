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

    result = Report.new(:date_from => Date.new(2006,4,1), :date_to => Date.new(2006,4,2)).summary
    assert_not_nil result[:visits]
    assert_equal 1, result[:visits].size
    assert_equal Date.new(2006,4,1), result[:visits].first[:date]
    assert_equal 1, result[:visits].first[:staff]
    assert_equal 3, result[:visits].first[:volunteer]
    assert_equal 2, result[:visits].first[:member]
    assert_equal 4, result[:visits].first[:patron]
  end
end
