require File.dirname(__FILE__) + '/../test_helper'

class OrganizationTest < ActiveSupport::TestCase

  def test_key_validation
    assert !Organization.new.valid?
    assert Organization.new(:name => 'Name', :key => 'key').valid?
    assert Organization.new(:name => 'Name', :key => 'a_key').valid?
    assert !Organization.new(:name => 'Name', :key => 'a key').valid?
    assert !Organization.new(:name => 'Name', :key => 'a').valid?
    assert !Organization.new(:name => 'Name', :key => 'a_very_long_key_is_invalid').valid?
    assert !Organization.new(:name => 'Name', :key => 'sfbk').valid? # unique
  end

  def test_find_by_key
    assert_equal organizations(:sfbk), Organization.find_by_key('sfbk')
  end

  def test_timezone
    assert_equal "Pacific Time (US & Canada)", Organization.new(:name => 'Name', :key => 'key').timezone
    assert_equal "Eastern Time (US & Canada)", Organization.new(:name => 'Name', :key => 'key', :timezone => 'Eastern Time (US & Canada)').timezone

    assert !Organization.new(:name => 'Name', :key => 'key', :timezone => 'invalid').valid?
  end

  def test_last_visit
    assert_equal organizations(:sfbk).last_visit.datetime.to_s(:db), '2007-02-02 18:02:00'
    assert_nil organizations(:cbi).last_visit
  end
end
