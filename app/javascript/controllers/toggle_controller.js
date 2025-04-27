import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["hamburgerButton", "dropdownButton", "dropdownMenu", "dropdownMenuItems", "closeMenuButton", "mobileMenu", "mobileMenuItems"]

  connect() {
    // console.log("toggle controller connected")
  }

  toggleDropdown() {
    const isExpanded = this.dropdownButtonTarget.getAttribute("aria-expanded") === "true"
    this.dropdownMenuTarget.classList.toggle("hidden")
    this.dropdownButtonTarget.setAttribute("aria-expanded", !isExpanded)
  }

  toggleDropdownItem() {
    const isExpanded = this.dropdownButtonTarget.getAttribute("aria-expanded") === "true"
    this.dropdownMenuTarget.classList.toggle("hidden")
    this.dropdownButtonTarget.setAttribute("aria-expanded", !isExpanded)
  }

  toggleMobileMenu() {
    const isExpanded = this.closeMenuButtonTarget.getAttribute("aria-expanded") === "true"
    this.mobileMenuTarget.classList.toggle("hidden")
    this.closeMenuButtonTarget.setAttribute("aria-expanded", !isExpanded)
  }

  toggleMobileMenuItems() {
    const isExpanded = this.closeMenuButtonTarget.getAttribute("aria-expanded") === "true"
    this.mobileMenuTarget.classList.toggle("hidden")
    this.closeMenuButtonTarget.setAttribute("aria-expanded", !isExpanded)
  }
}