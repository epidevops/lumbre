import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["flash"]

  connect() {
    // Observe the main content area
    this.mainContent = document.querySelector("#site-main")
    if (this.mainContent) {
      this.observer = new IntersectionObserver(this.handleIntersection.bind(this), {
        threshold: 0.1,
        rootMargin: "-100px 0px" // Add some margin to trigger before the element is fully in view
      })
      this.observer.observe(this.mainContent)
    }

    // Also observe the subscriptions form if it exists
    this.subscriptionsForm = document.querySelector("#subscriptions-form")
    if (this.subscriptionsForm) {
      this.formObserver = new IntersectionObserver(this.handleIntersection.bind(this), {
        threshold: 0.1,
        rootMargin: "-100px 0px"
      })
      this.formObserver.observe(this.subscriptionsForm)
    }
  }

  disconnect() {
    if (this.observer) {
      this.observer.disconnect()
    }
    if (this.formObserver) {
      this.formObserver.disconnect()
    }
  }

  handleIntersection(entries) {
    // The positioning is now handled by Tailwind classes
    // This method is kept for future use if needed
  }
}