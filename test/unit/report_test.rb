require File.dirname(__FILE__) + '/../test_helper'

class ReportTest < ActiveSupport::TestCase
  def test_summary
    result = Report.new.summary
    p result
  end
end
