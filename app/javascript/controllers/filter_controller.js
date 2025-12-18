import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  add(event) {
    const { searchKey, value } = event.detail;
    this.element.appendChild(this.buildHiddenInput(searchKey, value));
    this.element.requestSubmit();
  }

  remove(event) {
    event.target.closest(".control").remove();
    this.element.requestSubmit();
  }

  buildHiddenInput(fieldName, value) {
    const filter = document.createElement("input");
    filter.setAttribute("type", "hidden");
    filter.setAttribute("name", `filter[${fieldName}]`);
    filter.setAttribute("value", value);
    return filter;
  }
}
