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