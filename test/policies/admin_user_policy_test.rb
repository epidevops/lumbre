require "test_helper"

class Admin::AdminUserPolicyTest < ActiveSupport::TestCase
  setup do
    @super_admin = admin_users(:one)
    @manager = admin_users(:two)
  end

  test "scope honors configured current_admin_user index scope" do
    authorization = AccessAuthorization.create!(
      access_type: access_types(:resources),
      access_resource: access_resources(:admin_user),
      key: "admin_user_index_test",
      label: "AdminUser Index",
      action: "index"
    )
    permission = Permission.create!(role: roles(:manager))
    permission.permission_grants.create!(access_authorization: authorization, granted: true)
    permission.permission_resource_scopes.create!(
      access_resource: access_resources(:admin_user),
      index_scope_rule: index_scope_rules(:current_admin_user)
    )

    resolved = Admin::AdminUserPolicy::Scope.new(@manager, AdminUser).resolve

    assert_equal [ @manager.id ], resolved.pluck(:id)
  end

  test "scope honors configured role_peers index scope" do
    authorization = AccessAuthorization.create!(
      access_type: access_types(:resources),
      access_resource: access_resources(:admin_user),
      key: "admin_user_index_group_test",
      label: "AdminUser Index",
      action: "index"
    )
    permission = Permission.create!(role: roles(:manager))
    permission.permission_grants.create!(access_authorization: authorization, granted: true)
    permission.permission_resource_scopes.create!(
      access_resource: access_resources(:admin_user),
      index_scope_rule: index_scope_rules(:role_peers)
    )

    resolved = Admin::AdminUserPolicy::Scope.new(@manager, AdminUser).resolve
    expected_ids = @manager.peer_admin_user_ids

    assert_equal expected_ids.sort, resolved.pluck(:id).sort
  end
end
