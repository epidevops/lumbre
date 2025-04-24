# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "@hotwired--stimulus.js" # @3.2.2
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin "@rails/request.js", to: "@rails--request.js" # @0.0.11
pin "trix"
pin "@rails/actiontext", to: "actiontext.esm.js"
pin "sortablejs" # @1.15.6

pin_all_from "app/javascript/initializers", under: "initializers"
pin_all_from "app/javascript/lib", under: "lib"
pin_all_from "app/javascript/controllers", under: "controllers"
pin_all_from "app/javascript/helpers", under: "helpers"
pin "tailwindcss-stimulus-components" # @6.1.3
