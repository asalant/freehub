require 'test_helper'

class ApplicationHelperTest < ActiveSupport::TestCase

  def test_tab_item
    assert_match /selected/, tab_item('Home', '/', '/')
    assert_match /selected/, tab_item('Home', '/sfbk', '/sfbk')
    assert_no_match /selected/, tab_item('Home', '/sfbk', '/sfbk/edit')
    assert_match /selected/, tab_item('Visits', '/sfbk/visits', '/sfbk/visits', :select_children => true)
    assert_match /selected/, tab_item('Visits', '/sfbk/visits', '/sfbk/visits/2020/1/21', :select_children => true)
    assert_match /selected/, tab_item('Reports', '/sfbk/reports', '/sfbk/reports', :select_children => true)
    assert_match /selected/, tab_item('Reports', '/sfbk/reports', '/sfbk/reports/visits', :select_children => true)
    assert_match /selected/, tab_item('Settings', '/sfbk/edit', '/sfbk/edit')
    assert_no_match /selected/, tab_item('Settings', '/sfbk', '/sfbk/edit')
  end
end
