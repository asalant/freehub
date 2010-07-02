require 'test_helper'

class RoleTest < ActiveSupport::TestCase

  def test_admin_role
    assert users(:admin).is_admin?
    assert !users(:sfbk).is_admin?
  end

  def test_manager_role
    assert users(:sfbk).is_manager?
    assert users(:sfbk).is_manager_of?(organizations(:sfbk))
    assert !users(:sfbk).is_manager_of?(organizations(:scbc))
  end

end

