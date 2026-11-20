import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container", "template"]

  addRow(event) {
    event.preventDefault()
    const index = new Date().getTime()
    const content = this.templateTarget.innerHTML.replace(/NEW_RECORD/g, index)
    this.containerTarget.insertAdjacentHTML("beforeend", content)
  }

  removeRow(event) {
    event.preventDefault()
    const row = event.target.closest(".servicio-fila")
    if (row) {
      const allRows = this.containerTarget.querySelectorAll(".servicio-fila")
      if (allRows.length > 1) {
        row.remove()
      } else {
        const select = row.querySelector("select")
        const qty = row.querySelector("input[type='number']")
        if (select) select.value = ""
        if (qty) qty.value = "1"
      }
    }
  }
}
