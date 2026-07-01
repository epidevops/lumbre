# frozen_string_literal: true

module Admin
  module SuperAdminOnly
    extend ActiveSupport::Concern

    included do
      Admin::AuthorizesAccess::PUNDIT_ACTIONS.each do |action|
        define_method(:"#{action}?") do
          user.super_admin?
        end
      end
    end
  end
end
