import { Controller } from "@hotwired/stimulus"
import { autocomplete } from '@algolia/autocomplete-js'
import * as SearchSources from '../search_sources'

window.process = { env: {} }

export default class extends Controller {
  static targets = ["searchInput"]
  static values = {
    placeholder: String,
    sources: Array
  }

  onSelect(fieldName, value) {
    this.dispatch("autocompleteSelection", { prefix: "", detail: { fieldName: fieldName, value: value } })
    this.element.querySelector("form").reset()
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
