require "test_helper"

class AccessAuthorizationTest < ActiveSupport::TestCase
  test "navigation authorizations do not require resource or action" do
    authorization = access_authorizations(:application_nav)
    assert authorization.valid?
    assert authorization.navigation?
  end

  test "resource authorizations require resource and action" do
    authorization = access_authorizations(:restaurant_index)
    assert authorization.valid?
    assert authorization.resource_authorization?
  end

  test "allows prefixed resource actions" do
    authorization = AccessAuthorization.new(
      access_type: access_types(:resources),
      access_resource: access_resources(:admin_user),
      key: "admin_user_ma_otp_disable",
      label: "Admin User — Member: Otp disable",
      action: "ma_otp_disable"
    )

    assert authorization.valid?
  end

  test "allows collection action prefix" do
    authorization = AccessAuthorization.new(
      access_type: access_types(:resources),
      access_resource: access_resources(:product),
      key: "product_ca_update_positions",
      label: "Product — Collection: Update positions",
      action: "ca_update_positions"
    )

    assert authorization.valid?
  end
end
