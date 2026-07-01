# frozen_string_literal: true

class Admin::AdminUserPolicy < Admin::ApplicationPolicy
  class Scope < Admin::ApplicationPolicy::Scope
    def resolve
      return scope.all if user.super_admin?
      return scope.none unless user.authorized_for?("AdminUser", :index)

      case user.index_scope_for("AdminUser")
      when "current_admin_user"
        scope.where(id: user.id)
      when "role_peers"
        scope.where(id: user.peer_admin_user_ids)
      else
        scope.all
      end
    end
  end
end
