# frozen_string_literal: true

class AdminUsers::SessionsController < ActiveAdmin::Devise::SessionsController
  layout "active_admin_logged_out"
  helper ActiveAdmin::ViewHelpers

  def new
    super
  end

  def create
    self.resource = warden.authenticate!(auth_options)

    if resource&.valid_password?(params[:admin_user][:password])
      if resource.otp_required_for_login?
        session[:pending_admin_user_id] = resource.id
        warden.logout(resource_name)
        redirect_to admin_user_otp_challenge_path
      else
        super
      end
    else
      super
    end
  end

  def destroy
    session.delete(:pending_admin_user_id)
    super
  end
end
