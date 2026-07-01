require "test_helper"

class AdminAuthorizableTest < ActiveSupport::TestCase
  test "super admin is always authorized" do
    admin_user = admin_users(:one)

    assert admin_user.authorized_for?("Restaurant", :index)
    assert admin_user.authorized_nav?(:application)
    assert_equal "all", admin_user.index_scope_for("Restaurant")
  end

  test "granted page action is authorized for role with permission grant" do
    admin_user = admin_users(:one)

    assert admin_user.authorized_for?("Restaurant", :index)
  end

  test "missing grant is not authorized" do
    admin_user = admin_users(:two)

    assert_not admin_user.authorized_for?("Restaurant", :index)
    assert_not admin_user.authorized_nav?(:application)
  end

  test "index scope resolves from permission configuration" do
    admin_user = admin_users(:one)

    assert_equal "all", admin_user.index_scope_for("Restaurant")
  end

  test "granted collection action is authorized by bare action name" do
    authorization = AccessAuthorization.create!(
      access_type: access_types(:resources),
      access_resource: access_resources(:product),
      key: "product_ca_update_positions_test",
      label: "Product — Collection: Update positions",
      action: "ca_update_positions"
    )
    permission = Permission.create!(role: roles(:manager))
    grant = permission.permission_grants.create!(access_authorization: authorization, granted: true)
    manager = admin_users(:two)

    assert manager.authorized_for?("Product", :update_positions)

    grant.update!(granted: false)

    assert_not manager.authorized_for?("Product", :update_positions)
  end
end
