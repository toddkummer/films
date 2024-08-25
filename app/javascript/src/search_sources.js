export class SearchSource {
  static filterKey

  sourceId
  powerSearchCode
  powerSearchRegex = /^(?<code>[a-z{1,2}]):\s*(?<query>.*)/i
  minimumCharactersRequired = 1

  constructor(quickSearch) {
    this.quickSearch = quickSearch

    // these methods are used in callbacks by Algolia Autocomplete, so need to be bound to the instance
    this.getItems = this.getItems.bind(this)
    this.onSelect = this.onSelect.bind(this)
}

  getItems({ query }) {
    if (this.skip(query)) {
      return []
    } else {
      return this.fetchData(this.queryOptions(query))
    }
  }

  onSelect(params) {
    this.quickSearch.onSelect(this.constructor.filterKey, this.filterValue(params.item))
  }

  filterValue(item) {
    return item.id
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
  static filterKey = "name"
  sourceId = "name-contains"

  templates = {
      item({ item, html }) {
        return html`<span>Name contains "${item.name}"</span>`
      }
    }

  fetchData({query}) {
    return { name: query }
  }

  filterValue(item) {
    return item.name
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

  onSelect() { }
}

export class LocationsSource extends SearchSource {
  static filterKey = "location_id"
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
}


export class DirectorsSource extends PeopleSource {
  static filterKey = "director_id"
  static fetchDataAdditionalParams = "&filter[director]=true"

  sourceId = "directors"
  powerSearchCode = "D"

  templates = { ...this.templates,
                header() { return "Filter by director" }}
}

export class WritersSource extends PeopleSource {
  static filterKey = "writer_id"
  static fetchDataAdditionalParams = "&filter[writer]=true"

  sourceId = "writers"

  templates = { ...this.templates,
                header() { return "Filter by writer" }}
}

export class ActorsSource extends PeopleSource {
  static filterKey = "actor_id"
  static fetchDataAdditionalParams = "&filter[actor]=true"

  sourceId = "actors"

  templates = { ...this.templates,
                header() { return "Filter by actor" }}
}
