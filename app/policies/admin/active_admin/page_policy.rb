# frozen_string_literal: true

module Admin
  module ActiveAdmin
    class PagePolicy < Admin::ApplicationPolicy
      def show?
        return true if user.super_admin?

        user.authorized_for?(page_resource_class, :index)
      end

      private

        def page_resource_class
          AccessResource.page_resource_class(record)
        end
    end
  end
end
