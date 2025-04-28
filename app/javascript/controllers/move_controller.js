import { Controller } from "@hotwired/stimulus"
import Sortable from "sortablejs"

// Connects to data-controller="move"
export default class extends Controller {
  connect() {
    this.sortable = new Sortable(this.element, {
      animation: 150,
      ghostClass: "bg-blue-100"
    })
  }
}