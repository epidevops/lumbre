class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  include Internationalization

  def self.default_url_options(options = {})
    { locale: I18n.locale }.merge(options).compact_blank
  end

  def route_not_found
    redirect_to root_path, flash: { info: t("application.route_not_found") }
    # render file: Rails.public_path.join("404.html"), status: :not_found, layout: false
  end
end
