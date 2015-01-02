require 'test_helper'

class RolesTest <  ActiveSupport::TestCase
  include ApplicationHelper

  def test_admin_role
    User.current_user = users(:admin)
    assert user_is_admin?
    User.current_user = users(:greeter)
    assert !user_is_admin?
  end

  def test_manager_role
    User.current_user = users(:sfbk)
    @organization = organizations(:sfbk)
    assert user_is_manager?
    User.current_user = users(:scbc)
    assert !user_is_manager?
  end
end
