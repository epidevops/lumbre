# frozen_string_literal: true

module Admin
  module AuthorizesAccess
    extend ActiveSupport::Concern

    PUNDIT_ACTIONS = AccessAuthorization::STANDARD_ACTIONS

    included do
      PUNDIT_ACTIONS.each do |action|
        define_method(:"#{action}?") do
          admin_authorized?(action)
        end
      end
    end

    class_methods do
      def resource_name
        @resource_name ||= name.demodulize.sub(/Policy$/, "")
      end
    end

    def method_missing(name, *args, &block)
      if name.to_s.end_with?("?")
        action = name.to_s.delete_suffix("?")
        return admin_authorized?(action) if dynamic_admin_action?(action)
      end

      super
    end

    def respond_to_missing?(name, include_private = false)
      (name.to_s.end_with?("?") && dynamic_admin_action?(name.to_s.delete_suffix("?"))) || super
    end

    private

      def dynamic_admin_action?(action)
        action.start_with?("ma_", "ba_", "ca_", "ai_") ||
          AccessAuthorization::STANDARD_ACTIONS.exclude?(action)
      end

      def admin_authorized?(action)
        return true if user.super_admin?

        user.authorized_for?(policy_resource_name, action)
      end

      def policy_resource_name
        if record.is_a?(Class)
          record.name
        elsif record.respond_to?(:model_name)
          record.model_name.name
        else
          self.class.resource_name
        end
      end
  end
end
