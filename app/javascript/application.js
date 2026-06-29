// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "trix"
import "@rails/actiontext"
import "initializers"
import "controllers"
import "ahoy"

// Server-side tracking handles visits (including /admin). Disable JS visit
// creation to avoid duplicates; cookies are off per config/initializers/ahoy.rb.
window.ahoy.configure({ cookies: false, trackVisits: false })
// import "utils"
