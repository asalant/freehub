require 'test_helper'

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
    assert Organization.new(:name => 'Name', :key => 'key', :timezone => 'London').valid?
  end

  def test_last_visit
    assert_equal organizations(:sfbk).last_visit.arrived_at.to_s(:db), '2007-02-02 18:02:00'
    assert_nil organizations(:cbi).last_visit
  end

  def test_active?
    assert organizations(:sfbk).active?(Time.zone.parse '2007-02-28')
    assert !organizations(:sfbk).active?(Time.zone.parse '2007-04-01')
    assert !organizations(:cbi).active?(Time.zone.parse '2007-02-02')
  end

  def test_visits_count
    assert organizations(:sfbk).visits_count > 100
  end

  context 'Organization with tags' do
    should 'find all tag names in use' do
      assert_equal ['key holder', 'mechanic', 'mom'], organizations(:sfbk).tag_list
    end

    should 'find all tags in use' do
      assert_equal 3, organizations(:sfbk).tags.length
    end
  end
end

