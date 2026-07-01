# frozen_string_literal: true

class Admin::PermissionPolicy < Admin::ApplicationPolicy
  include Admin::SuperAdminOnly

  class Scope < Admin::ApplicationPolicy::Scope
    def resolve
      return scope.all if user.super_admin?

      scope.none
    end
  end
end
