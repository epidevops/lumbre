require "test_helper"

class Admin::ApplicationPolicyTest < ActiveSupport::TestCase
  setup do
    @super_admin = admin_users(:one)
    @manager = admin_users(:two)
  end

  test "scope resolves when pundit passes model class" do
    resolved = Admin::ApplicationPolicy::Scope.new(@super_admin, AdminUser).resolve

    assert_equal AdminUser.count, resolved.count
  end

  test "scope resolves when pundit passes relation" do
    resolved = Admin::ApplicationPolicy::Scope.new(@super_admin, AdminUser.all).resolve

    assert_equal AdminUser.count, resolved.count
  end

  test "scope returns none when index is not authorized" do
    resolved = Admin::ApplicationPolicy::Scope.new(@manager, Restaurant).resolve

    assert_empty resolved
  end
end
