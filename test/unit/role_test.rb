require 'test_helper'

class RoleTest < ActiveSupport::TestCase
  include ApplicationHelper

  def test_admin_role
    @current_user = users(:admin)
    assert user_is_admin?
    @current_user = users(:sfbk)
    assert !user_is_admin?
  end

  def test_manager_role
    @current_user = users(:sfbk)
    @organization = organizations(:sfbk)
    assert user_is_manager?
    @current_user = users(:scbc)
    assert !user_is_manager?
  end

end

