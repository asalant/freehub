require File.dirname(__FILE__) + '/../test_helper'

class MarkabyHelperTest < Test::Unit::TestCase

  include MarkabyHelper

  def fixme_test_labeled_input
    result = labeled_input 'Label' do
      'name'
    end
    assert_equal '<p><label>Label</label>name</p>', result.to_s
  end

  def fixme_test_labeled_input_with_for
    result = labeled_input 'Label', :for => :name do
      'name'
    end
    assert_equal '<p><label for="name">Label</label>name</p>', result.to_s
  end

  def test_labeled_value
    result = labeled_value 'Label', 'value'
    assert_equal '<div class="label">Label </div><span class="value">value</span><br/>', result.to_s
  end
end
