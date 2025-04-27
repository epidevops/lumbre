// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
import { Confetti } from "stimulus-confetti"
import { Sortable } from "sortablejs"

eagerLoadControllersFrom("controllers", application)

application.register("confetti", Confetti)
application.register("sortable", Sortable)