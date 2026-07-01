# frozen_string_literal: true

class Admin::ApplicationPolicy
  include Admin::AuthorizesAccess

  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      return scope.all if user.super_admin?
      return scope.none unless user.authorized_for?(resource_name, :index)

      apply_index_scope
    end

    private

      def resource_name
        model_class.name
      end

      def model_class
        scope.is_a?(Class) ? scope : scope.klass
      end

      def apply_index_scope
        case user.index_scope_for(resource_name)
        when "current_admin_user"
          scope_for_current_admin_user
        when "role_peers"
          scope_for_role_peers
        when "author"
          scope_for_author
        else
          scope.all
        end
      end

      def scope_for_current_admin_user
        return scope.where(id: user.id) if model_class == AdminUser
        return scope.where(admin_user: user) if admin_user_association?

        scope.all
      end

      def scope_for_role_peers
        peer_ids = user.peer_admin_user_ids

        return scope.where(id: peer_ids) if model_class == AdminUser
        return scope.where(admin_user_id: peer_ids) if column_names.include?("admin_user_id")

        scope.all
      end

      def scope_for_author
        return scope.where(author: user) if author_association?

        scope.all
      end

      def author_association?
        model_class.reflect_on_association(:author).present?
      end

      def admin_user_association?
        model_class.reflect_on_association(:admin_user).present?
      end

      def column_names
        model_class.column_names
      end
  end
end
