# frozen_string_literal: true

# Seeds role permissions from stable catalog keys (not database IDs).
# Requires access catalog seeds to run first.
module PermissionSeed
  PUNDIT = {
    role: "pundit",
    navigation: %w[administration dashboard],
    resources: {
      "admin_user" => %w[
        index show edit update
        ma_delete_avatar ma_otp_disable ma_otp_generate_new_backup_codes
        ma_switch_language ai_otp_toggle
      ]
    },
    pages: {
      "dashboard" => %w[index]
    },
    resource_scopes: {
      "admin_user" => "current_admin_user",
      default: "all"
    }
  }.freeze

  NEW_USER = {
    role: "new_user",
    navigation: %w[administration dashboard],
    resources: {
      "admin_user" => %w[
        index show edit update
        ma_delete_avatar ma_otp_disable ma_otp_generate_new_backup_codes
        ma_switch_language ai_otp_toggle
      ]
    },
    pages: {
      "dashboard" => %w[index]
    },
    resource_scopes: {
      "admin_user" => "current_admin_user",
      default: "all"
    }
  }.freeze

  class << self
    def run!
      seed_permission!(PUNDIT)
      seed_permission!(NEW_USER)
    end

    def seed_permission!(definition)
      role = Role.find_by!(name: definition[:role])
      permission = Permission.find_or_initialize_by(role: role)
      permission.save!

      seed_grants!(permission, definition)
      seed_resource_scopes!(permission, definition.fetch(:resource_scopes))

      permission
    end

    private

      def seed_grants!(permission, definition)
        authorizations_for(definition).each do |authorization|
          grant = permission.permission_grants.find_or_initialize_by(access_authorization: authorization)
          grant.granted = true
          grant.save!
        end
      end

      def authorizations_for(definition)
        grants = []

        Array(definition[:navigation]).each do |key|
          grants << AccessAuthorization.navigation.find_by!(key: key)
        end

        definition.fetch(:resources, {}).each do |resource_key, actions|
          access_resource = AccessResource.models.find_by!(key: resource_key)
          actions.each do |action|
            grants << AccessAuthorization.resources.find_by!(access_resource:, action:)
          end
        end

        definition.fetch(:pages, {}).each do |resource_key, actions|
          access_resource = AccessResource.pages.find_by!(key: resource_key)
          actions.each do |action|
            grants << AccessAuthorization.pages.find_by!(access_resource:, action:)
          end
        end

        grants
      end

      def seed_resource_scopes!(permission, scope_definition)
        default_scope_key = scope_definition.fetch(:default, "all")

        AccessResource.models.find_each do |access_resource|
          scope_key = scope_definition[access_resource.key] || default_scope_key
          index_scope_rule = IndexScopeRule.find_by!(key: scope_key)

          resource_scope = permission.permission_resource_scopes.find_or_initialize_by(access_resource:)
          resource_scope.index_scope_rule = index_scope_rule
          resource_scope.save!
        end
      end
  end
end
