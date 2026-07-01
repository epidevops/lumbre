# frozen_string_literal: true

module Admin
  module ActiveAdmin
    class CommentPolicy < Admin::ApplicationPolicy
      def destroy?
        return true if user.super_admin?

        record.author == user
      end

      class Scope < Admin::ApplicationPolicy::Scope
        def resolve
          return scope.all if user.super_admin?

          scope.where(author: user)
        end
      end
    end
  end
end
