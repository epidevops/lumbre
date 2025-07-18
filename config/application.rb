require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Lumbre
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.0

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    config.i18n.default_locale = :en
    config.i18n.available_locales = %i[en es fr de pt-BR es-MX]
    config.i18n.fallbacks = true

    config.view_component.component_parent_class = "ApplicationComponent"
    config.view_component.generate.sidecar = true
    config.view_component.generate.stimulus_controller = true
    config.view_component.generate.distinct_locale_files = true
    config.view_component.generate.preview = true
    config.view_component.generate.preview_path = "test/components/previews"
    config.view_component.show_previews = true
    config.lookbook.project_name = "Lumbre"

    config.active_record.encryption.support_unencrypted_data = true
    config.active_record.encryption.extend_queries = true

    # config.action_controller.default_url_options = { locale: I18n.locale }
    # config.action_mailer.default_url_options = { locale: I18n.locale }
  end
end
