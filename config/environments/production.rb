require "active_support/core_ext/integer/time"

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # Code is not reloaded between requests.
  config.enable_reloading = false

  # Eager load code on boot for better performance and memory savings (ignored by Rake tasks).
  config.eager_load = true

  # Full error reports are disabled.
  config.consider_all_requests_local = false

  # Turn on fragment caching in view templates.
  config.action_controller.perform_caching = true

  # Cache assets for far-future expiry since they are all digest stamped.
  config.public_file_server.headers = { "cache-control" => "public, max-age=#{1.year.to_i}" }

  # Enable serving of images, stylesheets, and JavaScripts from an asset server.
  # config.asset_host = "http://assets.example.com"

  # Store uploaded files in Tigris Global Object Storage (see config/storage.yml for options).
  config.active_storage.service = :tigris

  # Assume all access to the app is happening through a SSL-terminating reverse proxy.
  config.assume_ssl = true

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  config.force_ssl = true

  # Skip http-to-https redirect for the default health check endpoint.
  # config.ssl_options = { redirect: { exclude: ->(request) { request.path == "/up" } } }

  # Log to STDOUT with the current request id as a default log tag.
  config.log_tags = [ :request_id ]
  config.logger   = ActiveSupport::TaggedLogging.logger(STDOUT)

  # Change to "debug" to log everything (including potentially personally-identifiable information!).
  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info")

  # Prevent health checks from clogging up the logs.
  config.silence_healthcheck_path = "/up"

  # Don't log any deprecations.
  config.active_support.report_deprecations = false

  # Replace the default in-process memory cache store with a durable alternative.
  config.cache_store = :solid_cache_store

  # Replace the default in-process and non-durable queuing backend for Active Job.
  config.active_job.queue_adapter = :solid_queue
  # config.solid_queue.connects_to = { database: { writing: :queue, reading: :queue } }
  config.solid_queue.connects_to = { database: { writing: :queue } }
  config.solid_queue.silence_polling = true

  # Ignore bad email addresses and do not raise email delivery errors.
  # Set this to true and configure the email server for immediate delivery to raise delivery errors.
  # config.action_mailer.raise_delivery_errors = false

  # Set host to be used by links generated in mailer templates.
  # config.action_mailer.default_url_options = { host: "lumbre.fly.dev" }

  config.action_mailer.default_url_options = { locale: I18n.locale }.merge({ host: "lumbre.fly.dev" }).compact_blank

  config.action_mailer.delivery_method = :letter_opener_web
  config.action_mailer.perform_deliveries = true
  config.action_mailer.show_previews = true

  config.mission_control.jobs.http_basic_auth_enabled = false

  # config.active_storage.resolve_model_to_route = :rails_storage_proxy

  # TODO: Uncomment this when we have a production SMTP server
  # config.action_mailer.raise_delivery_errors = true
  # config.action_mailer.perform_deliveries = true
  # config.action_mailer.delivery_method = :smtp
  # config.action_mailer.default charset: "utf-8"
  # config.action_mailer.smtp_settings = {
  #   address: ENV.fetch("GMAIL_ADDRESS") { Rails.application.credentials.dig(:gmail_smtp, :address) },
  #   port: ENV.fetch("GMAIL_PORT") { Rails.application.credentials.dig(:gmail_smtp, :port) },
  #   user_name: ENV.fetch("GMAIL_USER_NAME") { Rails.application.credentials.dig(:gmail_smtp, :username) },
  #   password: ENV.fetch("GMAIL_APP_PASSWORD") { Rails.application.credentials.dig(:gmail_smtp, :app_password) },
  #   authentication: ENV.fetch("GMAIL_AUTHENTICATION") { Rails.application.credentials.dig(:gmail_smtp, :authentication) },
  #   enable_starttls_auto: ENV.fetch("GMAIL_STARTTLS_AUTO") { Rails.application.credentials.dig(:gmail_smtp, :enable_starttls_auto) }
  # }


  # Specify outgoing SMTP server. Remember to add smtp/* credentials via bin/rails credentials:edit.
  # config.action_mailer.smtp_settings = {
  #   user_name: Rails.application.credentials.dig(:smtp, :user_name),
  #   password: Rails.application.credentials.dig(:smtp, :password),
  #   address: "smtp.example.com",
  #   port: 587,
  #   authentication: :plain
  # }



  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation cannot be found).
  config.i18n.fallbacks = true

  # Do not dump schema after migrations.
  config.active_record.dump_schema_after_migration = false

  # Only use :id for inspections in production.
  config.active_record.attributes_for_inspect = [ :id ]

  # Enable DNS rebinding protection and other `Host` header attacks.
  # config.hosts = [
  #   "example.com",     # Allow requests from example.com
  #   /.*\.example\.com/ # Allow requests from subdomains like `www.example.com`
  # ]
  #
  # Skip DNS rebinding protection for the default health check endpoint.
  # config.host_authorization = { exclude: ->(request) { request.path == "/up" } }


  Flipper::UI.configure do |config|
    config.banner_text = "Production Environment"
    config.banner_class = "danger"
  end
end

# authenticate admin before redirecting to previewers
class ::Rails::MailersController
  before_action :authenticate_admin_user!
end

# authenticate admin for Rails info controllers
class ::Rails::InfoController
  include Rails.application.routes.url_helpers if Rails.env.production?

  skip_before_action :require_local! if Rails.env.production?
  before_action :authenticate_admin_user!
  before_action :ensure_super_admin!

  private

  def ensure_super_admin!
    redirect_to main_app.root_path unless current_admin_user&.super_admin?
  end
end
