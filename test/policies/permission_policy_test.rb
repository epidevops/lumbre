require "test_helper"

class Admin::PermissionPolicyTest < ActiveSupport::TestCase
  setup do
    @super_admin = admin_users(:one)
    @manager = admin_users(:two)
    @record = permissions(:super_admin_permission)
  end

  test "super admin can manage permissions" do
    policy = Admin::PermissionPolicy.new(@super_admin, @record)

    assert policy.index?
    assert policy.update?
  end

  test "non super admin cannot manage permissions" do
    policy = Admin::PermissionPolicy.new(@manager, @record)

    assert_not policy.index?
    assert_not policy.update?
  end
end
