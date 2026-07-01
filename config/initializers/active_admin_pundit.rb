# frozen_string_literal: true

Rails.application.config.to_prepare do
  ActiveAdmin::BaseController.class_eval do
    include Pundit::Authorization
    include DynamicPunditActions

    def pundit_user
      current_admin_user
    end
  end
end
