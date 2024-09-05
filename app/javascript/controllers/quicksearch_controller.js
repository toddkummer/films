import { Controller } from "@hotwired/stimulus"
import { autocomplete } from '@algolia/autocomplete-js'
import * as SearchSources from 'src/search_sources'

window.process = { env: {} }

export default class extends Controller {
  static targets = ["searchInput"]
  static values = {
    placeholder: String,
    sourceMapping: Object
  }

  onSelect(searchKey, value) {
    this.dispatch("autocompleteSelection", { prefix: "", detail: { searchKey: searchKey, value: value } })
    this.element.querySelector("form").reset()
  }

  connect() {
    // const sources = this.sourcesValue.map(source => new SearchSources[source](this))
    const sources = this.buildSources()

    this.instance = autocomplete({
      container: this.searchInputTarget,
      placeholder: this.placeholderValue,
      autofocus: true,
      getSources() { return sources },
    })
  }

  buildSources() {
    const callback = this.onSelect.bind(this)
    return Object.entries(this.sourceMappingValue).map(([searchKey, source]) => new SearchSources[source](searchKey, callback))
  }

  disconnect() {
    this.instance.destroy()
  }
}
