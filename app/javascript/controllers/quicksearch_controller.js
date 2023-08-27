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
    this.quickSearch.addFilter(`Name contains ${params.item.name}`, "name", params.item.name)
  }
}

class FilmsSource extends SearchSource {
  sourceId = "films"

  async fetchData(query) {
    const response = await fetch(`/films.json?name=${query}`)
    return await response.json()
  }

  templates = {
    header() {
      return 'Jump to...';
    },
    item({ item, html }) {
      return html`<a href="/films/${item.id}">${item.name} (${item.release_year})</a>`
    }
  }
}

class LocationsSource extends SearchSource {
  sourceId = "locations"

  async fetchData(query) {
    const response = await fetch(`/locations.json?name=${query}`)
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
    this.quickSearch.addFilter("Location: ", "location_id", params.item.id)
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
    const response = await fetch(`/people.json?name=${query}${this.constructor.fetchDataAdditionalParams}`)
    return await response.json()
  }

  onSelect = this.onSelect.bind(this)
  onSelect(params) {
    this.quickSearch.addFilter(`${this.constructor.filterLabel}: ${params.item.name}`, this.constructor.filterKey, params.item.id)
  }
}


class DirectorsSource extends PeopleSource {
  static filterLabel = "Director"
  static filterKey = "director_id"
  static fetchDataAdditionalParams = "&director=true"

  sourceId = "directors"

  templates = { ...this.templates,
                header() { return "Filter by director" }}
}

class WritersSource extends PeopleSource {
  static filterLabel = "Writer"
  static filterKey = "writer_id"
  static fetchDataAdditionalParams = "&writer=true"

  sourceId = "writers"

  templates = { ...this.templates,
                header() { return "Filter by writer" }}
}

class ActorsSource extends PeopleSource {
  static filterLabel = "Actor"
  static filterKey = "actor_id"
  static fetchDataAdditionalParams = "&actor=true"

  sourceId = "actors"

  templates = { ...this.templates,
                header() { return "Filter by actor" }}
}

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

  search() {
    const searchParams = new URLSearchParams();
    this.filterChipTargets.forEach((filterChip) => {
      console.log(filterChip)
      searchParams.append(filterChip.dataset.paramNameValue, filterChip.dataset.paramValue)
    })
    this.resultsTarget.src = `/films?${searchParams}`
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
