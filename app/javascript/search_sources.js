export class SearchSource {
  sourceId
  powerSearchCode
  powerSearchRegex = /^(?<code>[a-z{1,2}]):\s*(?<query>.*)/i
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
      return this.fetchData(this.queryOptions(query))
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

  queryOptions(query) {
    const found = query.match(this.powerSearchRegex)
    if (found === null) {
      return { query, limit: 5 }
    } else {
      return { query: found.groups.query, limit: 20 }
    }
  }

  fetchData({ query, limit }) {
    throw new Error('Method fetchData must be implemented')
  }
}

export class NameContainsSource extends SearchSource {
  sourceId = "name-contains"

  templates = {
      item({ item, html }) {
        return html`<span>Name contains "${item.name}"</span>`
      }
    }

  fetchData({query}) {
    return { name: query }
  }

  onSelect = this.onSelect.bind(this)
  onSelect(params) {
    this.quickSearch.addFilter(`Name contains ${params.item.name}`, "name", params.item.name)
  }
}

export class FilmsSource extends SearchSource {
  sourceId = "films"
  powerSearchCode = "F"

  async fetchData({ query, limit }) {
    const response = await fetch(`/films.json?filter[name]=${query}&limit=${limit}`)
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

export class LocationsSource extends SearchSource {
  sourceId = "locations"
  powerSearchCode = "L"

  async fetchData({ query, limit }) {
    const response = await fetch(`/locations.json?filter[name]=${query}&limit=${limit}`)
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
    this.quickSearch.addFilter(`Location: ${params.item.name}`, "location_id", params.item.id)
  }
}

export class PeopleSource extends SearchSource {
  static filterKey
  static fetchDataAdditionalParams

  templates = {
    item({ item }) {
      return `${item.name}`
    }
  }

  async fetchData({query, limit}) {
    const response = await fetch(`/people.json?filter[name]=${query}${this.constructor.fetchDataAdditionalParams}&limit=${limit}`)
    return await response.json()
  }

  onSelect = this.onSelect.bind(this)
  onSelect(params) {
    this.quickSearch.addFilter(`${this.constructor.filterLabel}: ${params.item.name}`, this.constructor.filterKey, params.item.id)
  }
}


export class DirectorsSource extends PeopleSource {
  static filterLabel = "Director"
  static filterKey = "director_id"
  static fetchDataAdditionalParams = "&filter[director]=true"

  sourceId = "directors"
  powerSearchCode = "D"

  templates = { ...this.templates,
                header() { return "Filter by director" }}
}

export class WritersSource extends PeopleSource {
  static filterLabel = "Writer"
  static filterKey = "writer_id"
  static fetchDataAdditionalParams = "&filter[writer]=true"

  sourceId = "writers"

  templates = { ...this.templates,
                header() { return "Filter by writer" }}
}

export class ActorsSource extends PeopleSource {
  static filterLabel = "Actor"
  static filterKey = "actor_id"
  static fetchDataAdditionalParams = "&filter[actor]=true"

  sourceId = "actors"

  templates = { ...this.templates,
                header() { return "Filter by actor" }}
}
