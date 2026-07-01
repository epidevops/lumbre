require "test_helper"
require Rails.root.join("script/permission_seed")

class PermissionSeedTest < ActiveSupport::TestCase
  setup do
    [
      [ AccessType::NAVIGATION, "Navigation" ],
      [ AccessType::RESOURCES, "Resources" ],
      [ AccessType::PAGES, "Pages" ]
    ].each do |key, name|
      AccessType.find_or_create_by!(key:) { |access_type| access_type.name = name }
    end

  [
    [ "all", "All records" ],
    [ "current_admin_user", "Current admin user" ],
    [ "role_peers", "Role peers" ],
    [ "author", "Author" ]
  ].each do |key, name|
    IndexScopeRule.find_or_create_by!(key:) { |rule| rule.name = name }
  end

    AccessControlCatalog.sync!
    Role.create!(name: "pundit")
  end

  test "seeds pundit permission grants and resource scopes from catalog keys" do
    permission = PermissionSeed.seed_permission!(PermissionSeed::PUNDIT)

    assert_equal "pundit", permission.role.name
    assert permission.granted?(AccessAuthorization.navigation.find_by!(key: "administration"))
    assert permission.granted?(AccessAuthorization.navigation.find_by!(key: "dashboard"))
    assert permission.granted?(AccessAuthorization.resources.find_by!(
      access_resource: AccessResource.find_by!(resource_class: "AdminUser"),
      action: "index"
    ))
    assert permission.granted?(AccessAuthorization.pages.find_by!(
      access_resource: AccessResource.pages.find_by!(key: "dashboard"),
      action: "index"
    ))

    admin_user_resource = AccessResource.find_by!(resource_class: "AdminUser")
    restaurant_resource = AccessResource.find_by!(resource_class: "Restaurant")

    assert_equal "current_admin_user",
      permission.resource_scope_for(admin_user_resource).index_scope_rule.key
    assert_equal "all",
      permission.resource_scope_for(restaurant_resource).index_scope_rule.key
  end
end
