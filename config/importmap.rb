# Pin npm packages by running ./bin/importmap

pin "application"

pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@rails/actioncable", to: "actioncable.esm.js"
pin "@rails/request.js", to: "@rails--request.js" # @0.0.11
pin "trix"
pin "@rails/actiontext", to: "actiontext.esm.js"
pin "flowbite", to: "https://cdn.jsdelivr.net/npm/flowbite@3.1.2/dist/flowbite.turbo.min.js"

pin_all_from "app/javascript/initializers", under: "initializers"
pin_all_from "app/javascript/lib", under: "lib"
pin_all_from "app/javascript/controllers", under: "controllers"
pin_all_from "app/javascript/helpers", under: "helpers"

pin "stimulus-confetti", to: "stimulus-confetti.js" # @1.0.1
pin "canvas-confetti", to: "canvas-confetti.js" # @1.9.3
pin "sortablejs", to: "sortablejs.js" # @1.15.6
