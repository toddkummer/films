export class SearchSource {
  static DEFAULT_LIMIT = 5
  static EXTENDED_SEARCH_LENGTH = 5
  static EXTENDED_SEARCH_LIMIT = 20
  static POWER_SEARCH_LIMIT = 20

  sourceId
  powerSearchCode
  powerSearchRegex = /^(?<code>[a-z{1,2}]):\s*(?<query>.*)/i
  minimumCharactersRequired = 1

  constructor(searchKey, onSelectCallback) {
    this.searchKey = searchKey
    this.sourceId = searchKey // required by AA, but not interesting to Quick Search
    this.onSelectCallback = onSelectCallback

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
    this.onSelectCallback(this.searchKey, this.filterValue(params.item))
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
      return { query, limit: this.determineLimit(query) }
    } else {
      return { query: found.groups.query, limit: this.constructor.POWER_SEARCH_LIMIT }
    }
  }

  determineLimit(query) {
    const len = query.length
    if (len < this.constructor.EXTENDED_SEARCH_LENGTH) {
      return this.constructor.DEFAULT_LIMIT
    } else {
      return this.constructor.EXTENDED_SEARCH_LIMIT
    }
  }

  fetchData({ query, limit }) {
    throw new Error('Method fetchData must be implemented')
  }
}

export class NameContainsSource extends SearchSource {
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
  powerSearchCode = "F"

  async fetchData({ query, limit }) {
    const response = await fetch(`/films.json?filter[name]=${query}&limit=${limit}`)
    return await response.json()
  }

  templates = {
    header() {
      return 'Filter by film';
    },
    item({ item }) {
      return `${item.name}`
    }
  }
}

export class FilmsJumpToSource extends FilmsSource {
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

export class LocationsJumpToSource extends LocationsSource {
  templates = {
    header() {
      return 'Jump to...'
    },
    item({ item, html }) {
      return html`<a href="/locations/${item.id}">${item.name}</a>`
    }
  }
}

export class PeopleSource extends SearchSource {
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
  static fetchDataAdditionalParams = "&filter[director]=true"

  powerSearchCode = "D"

  templates = { ...this.templates,
                header() { return "Filter by director" }}
}

export class WritersSource extends PeopleSource {
  static fetchDataAdditionalParams = "&filter[writer]=true"

  templates = { ...this.templates,
                header() { return "Filter by writer" }}
}

export class ActorsSource extends PeopleSource {
  static fetchDataAdditionalParams = "&filter[actor]=true"

  templates = { ...this.templates,
                header() { return "Filter by actor" }}
}
