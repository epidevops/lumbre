# frozen_string_literal: true

class Admin::AccessTypePolicy < Admin::ApplicationPolicy
  include Admin::SuperAdminOnly

  class Scope < Admin::ApplicationPolicy::Scope
    def resolve
      return scope.all if user.super_admin?

      scope.none
    end
  end
end
