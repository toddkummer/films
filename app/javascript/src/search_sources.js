import { SearchSource } from './search_source'

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
