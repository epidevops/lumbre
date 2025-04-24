import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  remove() {

    setTimeout(() => {
      this.element.remove()
    }, 3000)

  }
}
