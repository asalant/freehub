require File.dirname(__FILE__) + '/../test_helper'

class OrganizationTest < ActiveSupport::TestCase

  def test_find_by_key
    assert_equal organizations(:sfbk), Organization.find_by_key('sfbk')
  end
end
