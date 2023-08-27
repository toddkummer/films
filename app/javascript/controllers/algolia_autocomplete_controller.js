import { Controller } from "@hotwired/stimulus"
import { autocomplete } from '@algolia/autocomplete-js'
// import '@algolia/autocomplete-theme-classic';

window.process = { env: {} }

class SearchSource {
  sourceId
  powerSearchCode
  powerSearchRegex = /^(?<code>[a-z{1,2}]): (?<query>.*)/i
  minimumCharactersRequired = 1

  constructor(quickSearch) {
    this.quickSearch = quickSearch
  }

  // not sure why the method needs to also be exposed as a property,
  // this matches the object literal created in the examples
  getItems = this.getItems.bind(this)
  getItems({ query }) {
    if (this.skip(query)) {
      return []
    } else {
      return this.fetchData(this.extractQuery(query))
    }
  }

  skip(query) {
    return this.askingForHelp(query)  ||
      this.notEnoughCharacters(query) ||
      this.nonMatchingPowerSearch(query)
  }

  askingForHelp(query) {
    return 'help' === query.toLowerCase()
  }

  nonMatchingPowerSearch(query) {
    const found = query.match(this.powerSearchRegex)
    return found !== null && found.groups.code !== this.powerSearchCode
  }

  notEnoughCharacters(query) {
    return query.length < this.minimumCharactersRequired
  }

  extractQuery(query) {
    const found = query.match(this.powerSearchRegex)
    if (found === null) {
      return query
    } else {
      return found.groups.query
    }
  }

  fetchData(query) {
    throw new Error('Method fetchData must be implemented')
  }
}

class NameContainsSource extends SearchSource {
  sourceId = "name-contains"

  templates = {
      item({ item, html }) {
        return html`<span>Name contains "${item.name}"</span>`
      }
    }

  fetchData(query) {
    return { name: query }
  }

  onSelect = this.onSelect.bind(this)
  onSelect(params) {
    this.quickSearch.addFilter('name', params.item.name)
  }
}

class FilmsSource extends SearchSource {
  sourceId = "films"

  async fetchData(query) {
    const response = await fetch(`films.json?name=${query}`)
    return await response.json()
  }

  templates = {
    header() {
      return 'Jump to...';
    },
    item({ item, html }) {
      return html`<a href="films/${item.id}">${item.name} (${item.release_year})</a>`
    }
  }
}

class LocationsSource extends SearchSource {
  sourceId = "locations"

  async fetchData(query) {
    const response = await fetch(`locations.json?name=${query}`)
    return await response.json()
  }

  templates = {
    header() {
      return 'Filter by location'
    },
    item({ item }) {
      return `${item.name}`
    }
  }

  onSelect = this.onSelect.bind(this)
  onSelect(params) {
    this.quickSearch.addFilter('location_id', params.item.id)
  }
}

class PeopleSource extends SearchSource {
  static filterKey
  static fetchDataAdditionalParams

  templates = {
    item({ item }) {
      return `${item.name}`
    }
  }

  async fetchData(query) {
    const response = await fetch(`people.json?name=${query}${this.constructor.fetchDataAdditionalParams}`)
    return await response.json()
  }

  onSelect = this.onSelect.bind(this)
  onSelect(params) {
    this.quickSearch.addFilter(this.constructor.filterKey, params.item.id)
  }
}


class DirectorsSource extends PeopleSource {
  static filterKey = "director_id"
  static fetchDataAdditionalParams = "&director=true"

  sourceId = "directors"

  templates = { ...this.templates,
                header() { return "Filter by director" }}
}

class WritersSource extends PeopleSource {
  static filterKey = "writer_id"
  static fetchDataAdditionalParams = "&writer=true"

  sourceId = "writers"

  templates = { ...this.templates,
                header() { return "Filter by writer" }}
}

class ActorsSource extends PeopleSource {
  static filterKey = "actor_id"
  static fetchDataAdditionalParams = "&actor=true"

  sourceId = "actors"

  templates = { ...this.templates,
                header() { return "Filter by actor" }}
}

export default class extends Controller {
  static targets = ["searchInput", "results"]

  initialize() {
    this.query = {}
  }

  search() {
    const searchParams = new URLSearchParams(this.query);
    this.resultsTarget.src = `/films?${searchParams}`
  }

  addFilter(key, value) {
    this.query[key] = value
    this.search()
  }

  removeFilter(key) {
    delete this.query[key]
  }

  connect() {
    const sources = [
      new NameContainsSource(this),
      new FilmsSource(this),
      new LocationsSource(this),
      new DirectorsSource(this),
      new WritersSource(this),
      new ActorsSource(this)
    ]

    this.instance = autocomplete({
      container: this.searchInputTarget,
      placeholder: 'Search for films',
      autofocus: true,
      getSources() { return sources },
    })
  }

  disconnect() {
    this.instance.destroy()
  }
}
