# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Application Overview

Lumbre is a Ruby on Rails 8.1 application for a restaurant/hospitality business. It features:

- **Frontend**: Rails views with Tailwind CSS and Stimulus (Hotwire)
- **Backend**: Rails API with Active Admin for administration
- **Database**: SQLite with multiple databases (primary, cache, queue, cable)
- **Authentication**: Devise for both admin users and regular users
- **Feature Flags**: Flipper for feature management
- **Scheduling**: Ice Cube for recurring events/schedules
- **Multi-language**: I18n support (en, es, fr, de, pt-BR, es-MX)

## Development Commands

### Server and Development
```bash
# Start development server with all processes
foreman start -f Procfile.dev

# Individual components:
bin/rails server -p 3000              # Rails server
bin/rails tailwindcss:watch           # Tailwind CSS watcher
yarn build:css --watch                # CSS build watcher (Active Admin)
```

### Database Operations
```bash
# Setup databases
rake db:setup                          # Create all databases and load seeds
rake db:migrate                        # Run migrations on all databases
rake db:prepare                        # Setup if new, migrate if existing
rake db:reset                          # Drop, recreate, and seed all databases

# Individual database operations available for: primary, cache, queue, cable
rake db:migrate:primary                # Example: migrate specific database
```

### Testing
```bash
# Run tests
rake test                              # All tests except system tests
rake test:db                           # Reset DB and run tests
rake test:system                       # System tests only

# Test files located in:
# - test/models/
# - test/controllers/
# - test/system/
# - test/fixtures/
```

### Application Setup
```bash
# Setup complete application data (all environments)
rake lumbre:setup                      # Creates admin users, restaurant data, menu items, etc.

# Deployment setup
./bin/deploy-fly                       # Complete Fly.io deployment
rake fly:release                       # Fly.io release: db:create + db:migrate + lumbre:setup
```

### CSS and Assets
```bash
# Tailwind CSS (main application)
rake tailwindcss:build                 # Build Tailwind CSS
rake tailwindcss:watch                 # Watch and rebuild Tailwind CSS

# Active Admin CSS (separate build process)
yarn build:css                         # Build Active Admin CSS bundle
```

### Code Quality and Analysis
```bash
# Available via Gemfile gems:
bundle exec rubocop                    # Ruby style/lint checking (rails-omakase)
bundle exec brakeman                   # Security analysis
bundle exec bundler-audit              # Gem vulnerability scanning
bundle exec erb_lint                   # ERB template linting
bundle exec rubycritic                 # Code quality analysis
```

## Architecture and Key Components

### Core Models
- **Restaurant**: Main business entity with addresses, socials, products
- **Store**: Physical locations with schedules and events
- **User/AdminUser**: Dual authentication system with Devise
- **Schedule/ScheduleEvent**: Complex scheduling system using Ice Cube
- **Product**: Menu items and offerings

### Key Features
- **Active Admin**: Full admin interface at `/admin` (requires super_admin role)
- **Multi-tenancy**: Locale-scoped routing with I18n
- **Feature Flags**: Flipper integration for controlled feature rollouts
- **Solid Stack**: Using Solid Cache, Solid Queue, and Solid Cable
- **Component Architecture**: ViewComponent integration with Lookbook for previews

### Development Tools (Non-production)
Mounted engines available in development:
- `/blazer` - SQL dashboard and analytics
- `/exception-track` - Error tracking interface  
- `/flipper` - Feature flag management
- `/letter-opener` - Email preview
- `/litequeen` - Solid Litequeen interface
- `/jobs` - Mission Control Jobs dashboard
- `/lookbook` - ViewComponent previews
- `/active-storage-dashboard` - File management

### File Organization
- **Models**: Standard Rails models with concerns in `app/models/concerns/`
- **Controllers**: Organized with namespaced controllers (`static/`, `users/`)
- **Views**: Component-based with shared partials in `app/views/shared/`
- **JavaScript**: Stimulus controllers in `app/javascript/controllers/`
- **Styles**: Tailwind utilities with custom CSS in `app/assets/stylesheets/`
- **Admin**: ActiveAdmin resources in `app/admin/`

### Database Schema
Uses multiple SQLite databases:
- **Primary**: Application data (users, restaurants, schedules, etc.)
- **Cache**: Rails caching (Solid Cache)
- **Queue**: Background jobs (Solid Queue) 
- **Cable**: WebSocket connections (Solid Cable)

### Testing Strategy
- **Model Tests**: Unit tests for all models in `test/models/`
- **Controller Tests**: Integration tests in `test/controllers/`
- **System Tests**: Full-stack tests with Capybara/Selenium in `test/system/`
- **Fixtures**: Test data in `test/fixtures/`

## Common Development Patterns

### Adding New Features
1. Use feature flags via Flipper for gradual rollouts
2. Follow Rails conventions for MVC organization
3. Add translations for multi-language support
4. Include appropriate test coverage

### Working with Schedules
The application uses Ice Cube for complex recurring schedules. Schedule models have associated ScheduleEvents for specific occurrences.

### Admin Interface
ActiveAdmin provides full CRUD operations. Custom admin views use Arb templates in `app/admin/`.

### Internationalization
All user-facing strings should be translated. Available locales configured in `config/application.rb`.