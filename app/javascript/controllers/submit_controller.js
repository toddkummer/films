import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  submit(_event) {
    this.element.form.requestSubmit()
  }
}
