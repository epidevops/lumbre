# frozen_string_literal: true

# Binds Ahoy visits to the Rails session so a new browser session starts a new
# visit when someone leaves and returns. Visit duration is still enforced as a
# backstop for long-lived sessions.
module AhoySessionTracking
  extend ActiveSupport::Concern

  VISIT_TOKEN_SESSION_KEY = :ahoy_visit_token
  VISITOR_TOKEN_SESSION_KEY = :ahoy_visitor_token

  included do
    after_action :persist_ahoy_visit_session
  end

  def ahoy
    clear_stale_ahoy_visit_session!
    @ahoy ||= Ahoy::Tracker.new(
      controller: self,
      request: request,
      visit_token: session[VISIT_TOKEN_SESSION_KEY],
      visitor_token: session[VISITOR_TOKEN_SESSION_KEY]
    )
  end

  private

  def clear_stale_ahoy_visit_session!
    token = session[VISIT_TOKEN_SESSION_KEY]
    return if token.blank?

    visit = Ahoy::Visit.find_by(visit_token: token)
    return if visit && visit.started_at >= Ahoy.visit_duration.ago

    session.delete(VISIT_TOKEN_SESSION_KEY)
    session.delete(VISITOR_TOKEN_SESSION_KEY)
  end

  def persist_ahoy_visit_session
    return if ahoy_api_request?

    visit = ahoy.visit
    return unless visit

    session[VISIT_TOKEN_SESSION_KEY] = visit.visit_token
    session[VISITOR_TOKEN_SESSION_KEY] = visit.visitor_token if visit.visitor_token.present?
  end

  def ahoy_api_request?
    request.path.start_with?("/ahoy/")
  end
end
