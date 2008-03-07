require File.dirname(__FILE__) + '/../test_helper'

class OrganizationTest < ActiveSupport::TestCase

  def test_key_validation
    assert !Organization.new.valid?
    assert Organization.new(:name => 'Name', :key => 'key', :timezone => 'Pacific').valid?
    assert Organization.new(:name => 'Name', :key => 'a_key', :timezone => 'Pacific').valid?
    assert !Organization.new(:name => 'Name', :key => 'a key', :timezone => 'Pacific').valid?
    assert !Organization.new(:name => 'Name', :key => 'a', :timezone => 'Pacific').valid?
    assert !Organization.new(:name => 'Name', :key => 'a_very_long_key_is_invalid', :timezone => 'Pacific').valid?
    assert !Organization.new(:name => 'Name', :key => 'sfbk', :timezone => 'Pacific').valid? # unique
  end

  def test_find_by_key
    assert_equal organizations(:sfbk), Organization.find_by_key('sfbk')
  end
end
