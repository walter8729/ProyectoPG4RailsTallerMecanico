import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["panel", "content", "opener"]

  toggle() {
    this.panelTarget.classList.toggle("-translate-x-full")
    this.contentTarget.classList.toggle("ml-56")
    this.openerTarget.classList.toggle("hidden")
  }
}
