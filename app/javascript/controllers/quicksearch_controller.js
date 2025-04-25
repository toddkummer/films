import { Controller } from "@hotwired/stimulus"
import { autocomplete } from '@algolia/autocomplete-js'

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
    const sources = this.buildSourcesFromSourceMapping()
    this.instance = autocomplete(this.buildAutocompleteOptions(sources))
  }

  buildAutocompleteOptions(sources) {
    return {
      container: this.searchInputTarget,
      placeholder: this.placeholderValue,
      autofocus: true,
      getSources() { return sources },
    }
  }

  buildSourcesFromSourceMapping() {
    const callback = this.onSelect.bind(this)
    return Object.entries(this.sourceMappingValue)
                 .map(([searchKey, source]) => this.buildSource(searchKey, source, callback))
  }

  buildSource(searchKey, source, callback) {
    const sourceClass = this.lookupSourceClass(source)
    return new sourceClass(searchKey, callback)
  }

  lookupSourceClass(source){
    return this.application.quickSearchSources[source]
  }

  disconnect() {
    this.instance.destroy()
  }
}
