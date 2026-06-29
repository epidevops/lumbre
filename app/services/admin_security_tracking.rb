# frozen_string_literal: true

module AdminSecurityTracking
  EVENTS = {
    login_failed: "Admin login failed",
    otp_failed: "Admin OTP failed",
    login_rate_limited: "Admin login rate limited"
  }.freeze

  SECURITY_EVENT_NAMES = EVENTS.values.freeze

  module_function

  def track(request, name, properties = {})
    return unless request

    Ahoy::Tracker.new(request: request).track(
      name,
      properties.merge(category: "admin_security")
    )
  rescue StandardError => e
    Rails.logger.warn("Admin security tracking failed: #{e.message}")
  end

  def mask_email(email)
    return nil if email.blank?

    local, domain = email.to_s.split("@", 2)
    return "[redacted]" if domain.blank?

    visible = local.first(2).presence || local.first
    "#{visible}***@#{domain}"
  end
end
