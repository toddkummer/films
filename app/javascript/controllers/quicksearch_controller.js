import { Controller } from "@hotwired/stimulus"
import { autocomplete } from '@algolia/autocomplete-js'
import * as SearchSources from '../search_sources'

window.process = { env: {} }

class FilterChip {
  static build(document, label, name, value) {
    const builder = new this(label, name, value)
    return builder.createElement(document)
  }
  constructor(label, name, value) {
    this.label = label
    this.name = name
    this.value = value
  }

  createElement(document) {
    const chip = this.#buildButton(document)
    chip.appendChild(this.#buildLabel(document))
    chip.appendChild(this.#buildCloseButton(document))
    return chip
  }

  #buildButton(document) {
    const button = document.createElement("button")
    button.setAttribute('type', 'button')
    button.classList.add("ds-c-filter-chip__button")
    button.dataset.quicksearchTarget = "filterChip"
    button.dataset.paramNameValue = this.name
    button.dataset.paramValue = this.value

    return button
  }

  #buildLabel(document) {
    const label = document.createElement("span")
    label.classList.add("ds-c-filter-chip__label")
    label.appendChild(document.createTextNode(this.label))
    return label
  }

  #buildCloseButton(document) {
    const path = document.createElementNS("http://www.w3.org/2000/svg", "path")
    path.setAttribute("fill", "none")
    path.setAttribute("stroke", "currentColor")
    path.setAttribute("stroke-linecap", "round")
    path.setAttribute("strokeWidth", "2")
    path.setAttribute("d", "M0 13.0332964L13.0332964 0M13.0332964 13.0332964L0 0")

    const svg = document.createElementNS("http://www.w3.org/2000/svg", "svg")
    svg.classList.add("ds-c-icon", "ds-c-icon--close", "ds-c-icon--close-thin")
    svg.setAttribute("viewBox", "-2 -2 18 18")
    svg.appendChild(path)

    const container = document.createElement("span")
    container.classList.add("ds-c-filter-chip__clear-icon-container", "ds-c-filter-chip__clear-icon-alternate-container")
    container.dataset.action = "click->quicksearch#removeFilter"
    container.appendChild(svg)

    return container
  }
}

export default class extends Controller {
  static targets = ["searchInput", "filterChips", "filterChip", "results"]
  static values = {
    path: String,
    placeholder: String,
    sources: Array
  }

  search() {
    const searchParams = new URLSearchParams();
    this.filterChipTargets.forEach((filterChip) => {
      searchParams.append(`filter[${filterChip.dataset.paramNameValue}]`, filterChip.dataset.paramValue)
    })
    this.resultsTarget.src = `${this.pathValue}?${searchParams}`
  }

  addFilter(label, name, value) {
    this.filterChipsTarget.appendChild(FilterChip.build(document, label, name, value))
    this.element.querySelector("form").reset()
    this.search()
  }

  removeFilter(event) {
    event.currentTarget.closest("button").remove()
    this.search()
  }

  connect() {
    const sources = this.sourcesValue.map(source => new SearchSources[source](this))

    this.instance = autocomplete({
      container: this.searchInputTarget,
      placeholder: this.placeholderValue,
      autofocus: true,
      getSources() { return sources },
    })
  }

  disconnect() {
    this.instance.destroy()
  }
}
