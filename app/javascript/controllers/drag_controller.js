import { Controller } from "@hotwired/stimulus"
import Sortable from "sortablejs"
import { patch } from "@rails/request.js"

// Connects to data-controller="drag"
export default class extends Controller {
  static values = {
    resourceName: String,
    paramName: {
      type: String,
      default: "position",
    },
    responseKind: {
      type: String,
      default: "html",
    },
    animation: Number,
    handle: String,
  }

  initialize() {
    this.onUpdate = this.onUpdate.bind(this)
  }

  connect() {
    this.sortable = new Sortable(this.element, {
      ...this.defaultOptions,
      ...this.options,
    })
  }

  disconnect() {
    this.sortable.destroy()
    this.sortable = undefined
  }

  async onUpdate({ item, newIndex }) {
    if (!item.dataset.dragUpdateUrl) return

    const param = this.resourceNameValue ? `${this.resourceNameValue}[${this.paramNameValue}]` : this.paramNameValue

    const data = new FormData()
    data.append(param, newIndex + 1)

    return await patch(item.dataset.dragUpdateUrl, { body: data, responseKind: this.responseKindValue })
  }

  get options() {
    return {
      animation: this.animationValue || this.defaultOptions.animation || 150,
      handle: this.handleValue || this.defaultOptions.handle,
      onUpdate: this.onUpdate,
    }
  }

  get defaultOptions() {
    return {
      animation: 150,
      handle: ".drag-handle",
    }
  }
}