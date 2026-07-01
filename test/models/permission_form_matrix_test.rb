require "test_helper"

class PermissionFormMatrixTest < ActiveSupport::TestCase
  test "navigation rows use enabled column" do
    matrix = PermissionFormMatrix.new(permissions(:super_admin_permission), access_types(:navigation))

    assert matrix.navigation?
    assert_equal [ "enabled" ], matrix.action_columns
    assert_equal "application", matrix.rows.find { |row| row[:key] == "application" }[:key]
    assert matrix.rows.first[:cells].key?("enabled")
  end

  test "resource rows group by resource with index scope column" do
    matrix = PermissionFormMatrix.new(permissions(:super_admin_permission), access_types(:resources))

    assert matrix.resources?
    assert_includes matrix.action_columns, "index"
    restaurant_row = matrix.rows.find { |row| row[:key] == "restaurant" }

    assert_not_nil restaurant_row
    assert_not_nil restaurant_row[:cells]["index"]
    assert_not_nil restaurant_row[:resource_scope]
  end

  test "page rows expose defined page actions" do
    matrix = PermissionFormMatrix.new(permissions(:super_admin_permission), access_types(:pages))

    assert matrix.pages?
    assert_includes matrix.action_columns, "index"
  end
end
