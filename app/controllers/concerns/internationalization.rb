# controllers/concerns/internationalization.rb
module Internationalization
  extend ActiveSupport::Concern
  include TranslationsHelper

  included do
    before_action :set_locale # , :set_content_language
    # around_action :switch_locale
    helper_method :flag_for_locale

    private

    def derive_locale
      locale_from_url || locale_from_headers || I18n.default_locale
    end

    def admin_path?
      admin_path = "/admin"
      localized_admin_paths = I18n.available_locales.map { |locale| "/#{locale}/admin" }
      request.path.start_with?(admin_path) || localized_admin_paths.any? { |path| request.path.start_with?(path) }
    end

    def derive_user_locale
      locale_for_current_user || derive_locale
    end

    def derive_admin_user_locale
      locale_from_current_admin_user || derive_locale
    end

    def set_locale
      if admin_path?
        locale = derive_admin_user_locale
        response.set_header "Content-Language", locale
        I18n.locale = locale
      else
        locale = derive_user_locale
        response.set_header "Content-Language", locale
        I18n.locale = locale
      end
    end

    def set_content_language
      if admin_path?
        Mobility.locale = derive_admin_user_locale
      else
        Mobility.locale = derive_user_locale
      end
    end

    # def switch_locale(&action)
    #   locale = locale_from_url || locale_from_headers || I18n.default_locale
    #   response.set_header "Content-Language", locale
    #   I18n.with_locale(locale, &action)
    # end

    def locale_from_url
      locale = params[:locale]
      locale if I18n.available_locales.map(&:to_s).include?(locale)
    end

    def locale_from_headers
      header = request.env["HTTP_ACCEPT_LANGUAGE"]
      return if header.nil?

      locales = parse_header(header)
      return if locales.empty?

      detect_from_available(locales)
    end

    def parse_header(header)
      header.gsub(/\s+/, "").split(",").map do |tag|
        locale, quality = tag.split(/;q=/i)
        quality = quality ? quality.to_f : 1.0
        [ locale, quality ]
      end.reject { |(locale, quality)| locale == "*" || quality.zero? }
         .sort_by { |(_, quality)| quality }
         .map(&:first)
    end

    def detect_from_available(locales)
      locales.reverse.find { |l| I18n.available_locales.any? { |al| match?(al, l) } }
    end

    def match?(str1, str2)
      str1.to_s.casecmp(str2.to_s).zero?
    end


    # Get locale from top-level domain or return +nil+ if such locale is not available
    # You have to put something like:
    #   127.0.0.1 application.com
    #   127.0.0.1 application.it
    #   127.0.0.1 application.pl
    # in your /etc/hosts file to try this out locally
    def extract_locale_from_tld
      parsed_locale = request.host.split(".").last
      I18n.available_locales.map(&:to_s).include?(parsed_locale) ? parsed_locale : nil
    end

    # Get locale code from request subdomain (like http://it.application.local:3000)
    # You have to put something like:
    #   127.0.0.1 it.application.local
    # in your /etc/hosts file to try this out locally
    #
    # Additionally, you need to add the following configuration to your config/environments/development.rb:
    #   config.hosts << 'it.application.local:3000'
    def extract_locale_from_subdomain
      parsed_locale = request.subdomains.first
      I18n.available_locales.map(&:to_s).include?(parsed_locale) ? parsed_locale : nil
    end

    def locale_for_current_user
      return nil unless respond_to?(:current_user)
      return nil unless user_signed_in?
      return nil unless current_user.preferred_language.present?
      current_user.preferred_language
    end

    def locale_from_current_admin_user
      return nil unless respond_to?(:current_admin_user)
      return nil unless admin_user_signed_in?
      return nil unless current_admin_user.preferred_language.present?
      current_admin_user.preferred_language
    end

    # def default_url_options(options = {})
    #   if admin_path?
    #     { locale: derive_admin_user_locale }.merge(options).compact_blank
    #   else
    #     { locale: derive_user_locale }.merge(options).compact_blank
    #   end
    # end



    # def skip_locale_switch?
    #   # Skip locale switching for mounted engines
    #   Rails.application.routes.routes.any? do |route|
    #     next false unless route.app.respond_to?(:instance_variable_get)

    #     app = route.app.instance_variable_get(:@app)
    #     next false unless app

    #     # Check if it's an engine or if the path matches
    #     (app.to_s.include?("::Engine") || app.is_a?(Rails::Engine)) &&
    #       route.path.match?(request.path)
    #   end
    # end
  end
end
