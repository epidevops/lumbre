import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["flash"]

  connect() {
    this.mainContent = document.querySelector("main")
    if (this.mainContent) {
      this.observer = new IntersectionObserver(this.handleIntersection.bind(this), {
        threshold: 0.1
      })
      this.observer.observe(this.mainContent)
    }
  }

  disconnect() {
    if (this.observer) {
      this.observer.disconnect()
    }
  }

  handleIntersection(entries) {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        this.element.classList.remove("fixed")
        this.element.classList.add("relative")
      } else {
        this.element.classList.remove("relative")
        this.element.classList.add("fixed")
      }
    })
  }
}