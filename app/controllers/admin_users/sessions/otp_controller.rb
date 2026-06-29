# frozen_string_literal: true

class AdminUsers::Sessions::OtpController < ActiveAdmin::Devise::SessionsController
  layout "active_admin_logged_out"
  helper ActiveAdmin::ViewHelpers

  rate_limit to: 10, within: 3.minutes, only: :verify, with: -> {
    AdminSecurityTracking.track(
      request,
      AdminSecurityTracking::EVENTS[:login_rate_limited],
      stage: "otp",
      admin_user_id: session[:pending_admin_user_id]
    )
    redirect_to admin_user_otp_challenge_path, alert: "Try again later."
  }

  before_action :ensure_otp_pending_session
  before_action :set_resource, only: [ :challenge, :verify ]

  def challenge
  end

  def verify
    if resource.validate_and_consume_otp!(params[:admin_user][:otp_attempt]) || resource.invalidate_otp_backup_code!(params[:admin_user][:otp_attempt])
      session.delete(:pending_admin_user_id)
      sign_in(resource_name, resource)
      redirect_to admin_dashboard_path, notice: t("active_admin.otp.session.success")
    else
      AdminSecurityTracking.track(
        request,
        AdminSecurityTracking::EVENTS[:otp_failed],
        admin_user_id: resource.id,
        email: AdminSecurityTracking.mask_email(resource.email)
      )
      render :challenge, alert: t("active_admin.otp.session.invalid_code")
    end
  end

  def cancel
    # Allow user to cancel OTP flow and return to login
    session.delete(:pending_admin_user_id)
    redirect_to new_admin_user_session_path, notice: t("active_admin.otp.session.cancelled")
  end

  private

  def ensure_otp_pending_session
    unless session[:pending_admin_user_id]
      redirect_to new_admin_user_session_path, alert: t("active_admin.otp.session.expired")
    end
  end

  def set_resource
    self.resource = resource_class.find_by(id: session[:pending_admin_user_id])
  end
end
