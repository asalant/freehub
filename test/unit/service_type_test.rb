require File.dirname(__FILE__) + '/../test_helper'

class ServiceTypeTest < Test::Unit::TestCase

  def test_new
    membership = ServiceType.new('MEMBERSHIP', "Membership", "Membership for this shop.")
    assert_equal "MEMBERSHIP", membership.id
  end

  def test_indexed
    assert_equal 'MEMBERSHIP', ServiceType[:membership].id
  end
end
