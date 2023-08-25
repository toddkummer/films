import { Controller } from "@hotwired/stimulus"
import { autocomplete } from '@algolia/autocomplete-js'
// import '@algolia/autocomplete-theme-classic';

window.process = { env: {} }

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
  }

  removeFilter(key) {
    delete this.query[key]
  }

  connect() {
    const controller = this

    this.instance = autocomplete({
      container: this.searchInputTarget,
      placeholder: 'Search for films',
      autofocus: true,

      getSources() {
        return [
          {
            sourceId: 'query_film',
            getItems({ query }) {
              return { name: query }
            },
            templates: {
              item({ item, html }) {
                return html`<span>Name contains "${item.name}"</span>`
              }
            },
            onSelect(params) {
              controller.addFilter('name', params.item.name)
              controller.search()
            }
          },
          {
            sourceId: 'films',
            async getItems({ query }) {
              const response = await fetch(`films.json?name=${query}`)
              return await response.json()
            },
            templates: {
              header() {
                return 'Jump to...';
              },
              item({ item, html }) {
                return html`<a href="films/${item.id}">${item.name} (${item.release_year})</a>`
              }
            }
          },
          {
            sourceId: 'locations',
            async getItems({ query }) {
              const response = await fetch(`locations.json?name=${query}`)
              return await response.json()
            },
            templates: {
              header() {
                return 'Filter by location'
              },
              item({ item }) {
                return `${item.name}`
              }
            },
            onSelect(params) {
              controller.addFilter('location_id', params.item.id)
              controller.search()
            }
          },
          {
            sourceId: 'directors',
            async getItems({ query }) {
              const response = await fetch(`people.json?name=${query}&director=true`)
              return await response.json()
            },
            templates: {
              header() {
                return 'Filter by director'
              },
              item({ item }) {
                return `${item.name}`
              }
            },
            onSelect(params) {
              controller.addFilter('director_id', params.item.id)
              controller.search()
            }
          },
          {
            sourceId: 'actors',
            async getItems({ query }) {
              const response = await fetch(`people.json?name=${query}&actor=true`)
              return await response.json()
            },
            templates: {
              header() {
                return 'Filter by actor'
              },
              item({ item }) {
                return `${item.name}`
              }
            },
            onSelect(params) {
              controller.addFilter('actor_id', params.item.id)
              controller.search()
            }
          },
          {
            sourceId: 'writers',
            async getItems({ query }) {
              const response = await fetch(`people.json?name=${query}&writer=true`)
              return await response.json()
            },
            templates: {
              header() {
                return 'Filter by writer'
              },
              item({ item }) {
                return `${item.name}`
              }
            },
            onSelect(params) {
              controller.addFilter('writer_id', params.item.id)
              controller.search()
            }
          }
        ];
      },
    })
  }

  disconnect() {
    this.instance.destroy()
  }
}
