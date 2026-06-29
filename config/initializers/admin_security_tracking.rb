# frozen_string_literal: true

Rails.application.config.after_initialize do
  Warden::Manager.before_failure do |env, opts|
    next unless opts[:scope] == :admin_user

    request = ActionDispatch::Request.new(env)
    email = request.params.dig(:admin_user, :email)

    AdminSecurityTracking.track(
      request,
      AdminSecurityTracking::EVENTS[:login_failed],
      email: AdminSecurityTracking.mask_email(email),
      reason: opts[:message].to_s.presence,
      strategy: opts[:action].to_s.presence
    )
  end
end
