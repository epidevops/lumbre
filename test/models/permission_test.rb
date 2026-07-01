require "test_helper"

class PermissionTest < ActiveSupport::TestCase
  test "belongs to role and tracks grants" do
    permission = permissions(:super_admin_permission)
    assert_equal roles(:super_admin), permission.role
    assert_includes permission.granted_access_types, access_types(:navigation)
    assert permission.granted?(access_authorizations(:application_nav))
  end

  test "assign_default_grants builds unchecked catalog entries" do
    permission = Permission.new(role: roles(:manager))
    permission.assign_default_grants!

    assert permission.permission_grants.any?
    assert permission.permission_grants.all? { |grant| grant.granted == false }
    assert_empty permission.permission_resource_scopes
  end

  test "grant_for builds an unchecked grant when missing" do
    permission = Permission.new(role: roles(:developer))
    authorization = access_authorizations(:restaurant_index)

    grant = permission.grant_for(authorization)

    assert_not grant.persisted?
    assert_not grant.granted
    assert_equal authorization, grant.access_authorization
  end

  test "saves nested grant and resource scope attributes" do
    role = roles(:manager)
    authorization = access_authorizations(:restaurant_index)
    access_resource = access_resources(:restaurant)
    index_scope_rule = index_scope_rules(:current_admin_user)

    permission = Permission.create!(
      role: role,
      permission_grants_attributes: [
        { access_authorization_id: authorization.id, granted: true }
      ],
      permission_resource_scopes_attributes: {
        "0" => {
          access_resource_id: access_resource.id,
          index_scope_rule_id: index_scope_rule.id
        }
      }
    )

    assert permission.granted?(authorization)
    assert_equal "current_admin_user", permission.resource_scope_for(access_resource).index_scope_rule.key
  end

  test "rejects blank resource scope nested attributes" do
    role = roles(:developer)
    access_resource = access_resources(:restaurant)
    index_scope_rule = index_scope_rules(:role_peers)

    permission = Permission.new(
      role: role,
      permission_resource_scopes_attributes: {
        "blank" => { access_resource_id: "", index_scope_rule_id: index_scope_rule.id },
        "0" => {
          access_resource_id: access_resource.id,
          index_scope_rule_id: index_scope_rule.id
        }
      }
    )

    assert permission.valid?
    assert_equal 1, permission.permission_resource_scopes.size
    assert_equal access_resource.id, permission.permission_resource_scopes.first.access_resource_id
  end

  test "dedupes duplicate resource scopes on save keeping persisted record" do
    role = roles(:developer)
    access_resource = access_resources(:restaurant)
    permission = Permission.new(role: role)
    permission.permission_resource_scopes.build(
      access_resource: access_resource,
      index_scope_rule: index_scope_rules(:all)
    )
    permission.permission_resource_scopes.build(
      access_resource: access_resource,
      index_scope_rule: index_scope_rules(:role_peers)
    )

    assert permission.valid?
    assert_equal "role_peers", permission.permission_resource_scopes.reject(&:marked_for_destruction?).sole.index_scope_rule.key
  end

  test "strong params permit nested resource scope attributes" do
    raw = {
      "permission" => {
        "role_id" => roles(:developer).id.to_s,
        "permission_grants_attributes" => {
          "0" => { "access_authorization_id" => access_authorizations(:restaurant_index).id.to_s, "granted" => "1" }
        },
        "permission_resource_scopes_attributes" => {
          "0" => {
            "access_resource_id" => access_resources(:restaurant).id.to_s,
            "index_scope_rule_id" => index_scope_rules(:current_admin_user).id.to_s
          }
        }
      }
    }

    permitted = ActionController::Parameters.new(raw)
      .require(:permission)
      .permit(
        :role_id,
        permission_grants_attributes: %i[id permission_id access_authorization_id granted created_at updated_at _destroy],
        permission_resource_scopes_attributes: %i[id permission_id access_resource_id index_scope_rule_id created_at updated_at _destroy]
      )

    scopes = permitted[:permission_resource_scopes_attributes]
    grants = permitted[:permission_grants_attributes]
    assert_equal index_scope_rules(:current_admin_user).id.to_s, scopes["0"]["index_scope_rule_id"]
    assert_equal "1", grants["0"]["granted"]
  end
end
