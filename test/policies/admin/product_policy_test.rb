require "test_helper"

class Admin::ProductPolicyTest < ActiveSupport::TestCase
  setup do
    @super_admin = admin_users(:one)
    @manager = admin_users(:two)
    @record = products(:one)
  end

  test "super admin can manage products" do
    policy = Admin::ProductPolicy.new(@super_admin, @record)

    assert policy.index?
    assert policy.update?
  end

  test "manager without grants cannot manage products" do
    policy = Admin::ProductPolicy.new(@manager, @record)

    assert_not policy.index?
    assert_not policy.update?
  end
end
