require "test_helper"

class AdminUserTest < ActiveSupport::TestCase
  test "assigns roles through role_ids" do
    admin_user = admin_users(:two)
    manager_role = roles(:manager)
    developer_role = roles(:developer)

    admin_user.role_ids = [ developer_role.id ]
    admin_user.save!

    assert_equal [ developer_role ], admin_user.reload.roles.to_a
    assert_not admin_user.has_role?(:manager)

    admin_user.role_ids = [ manager_role.id, developer_role.id ]
    admin_user.save!

    assert admin_user.has_role?(:manager)
    assert admin_user.has_role?(:developer)
  end

  test "clears roles when role_ids is empty" do
    admin_user = admin_users(:two)

    admin_user.role_ids = []
    admin_user.save!

    assert_empty admin_user.reload.roles
  end
end
