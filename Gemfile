source "https://rubygems.org"

# Use main development branch of Rails
gem "rails", github: "rails/rails", branch: "main"
# The modern asset pipeline for Rails [https://github.com/rails/propshaft]
# gem "propshaft"
# Use sqlite3 as the database for Active Record
gem "sqlite3", ">= 2.1"
# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"
# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"
# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"
# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"
# Use Tailwind CSS [https://github.com/rails/tailwindcss-rails]
# gem "tailwindcss-rails"
gem "sprockets-rails"
gem "cssbundling-rails"
gem "tailwindcss-rails", "~> 4.2"

# Deploy this application anywhere as a Docker container [https://kamal-deploy.org]
gem "kamal", require: false

# Add HTTP asset caching/compression and X-Sendfile acceleration to Puma [https://github.com/basecamp/thruster/]
gem "thruster", require: false

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Use the database-backed adapters for Rails.cache, Active Job, and Action Cable
gem "solid_cache"
gem "solid_queue"
gem "solid_cable"
gem "solid_litequeen", "~> 0.17.2"
gem "mission_control-jobs", "~> 1.0"

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
gem "image_processing", "~> 1.2"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"

  # Audits gems for known security defects (use config/bundler-audit.yml to ignore issues)
  gem "bundler-audit", require: false

  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem "brakeman", require: false

  # Omakase Ruby styling [https://github.com/rails/rubocop-rails-omakase/]
  gem "rubocop-rails-omakase", require: false

  gem "dotenv", "~> 3.1"
  gem "letter_opener_web", "~> 3.0"
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"
  gem "erb_lint", "~> 0.9.0", require: false
  gem "rdoc", "~> 6.14", require: false # rdoc --root="app/"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver"
end

gem "activeadmin", "~> 4.0.0.beta15"
# gem "activeadmin_assets"
# gem "activeadmin_assets", path: "/Users/jasonrossi/Sandbox/forked_repo/activeadmin_assets"
gem "devise", github: "heartcombo/devise", branch: "main"
gem "devise-i18n", "~> 1.13"
gem "rails-i18n", "~> 8.0"
gem "mobility", "~> 1.3"

gem "rolify", "~> 6.0"
gem "name_of_person", "~> 1.1"

gem "inline_svg", "~> 1.10"
gem "rails_heroicon", "~> 2.3"

gem "view_component", "~> 3.23"
gem "lookbook", "~> 2.3"
gem "listen", "~> 3.9"

gem "noticed", "~> 2.7"

gem "exception-track", "~> 1.3"
gem "flipper", "~> 1.3"
gem "flipper-active_record", "~> 1.3"
gem "flipper-ui", "~> 1.3"
gem "blazer", "~> 3.3"
gem "active_storage_dashboard", "~> 0.1.7"
gem "vernier", "~> 1.0"
gem "profile-viewer", "~> 0.0.5"

gem "sequenced", "~> 4.0"
gem "positioning", "~> 0.4.5"
gem "acts_as_list", "~> 1.2"
gem "ice_cube", "~> 0.17.0"

gem "simple_calendar", "~> 3.1"

gem "rubycritic", require: false
