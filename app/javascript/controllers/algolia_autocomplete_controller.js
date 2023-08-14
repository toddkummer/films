import { Controller } from "@hotwired/stimulus"
import { autocomplete } from '@algolia/autocomplete-js'
// import '@algolia/autocomplete-theme-classic';

window.process = { env: {} }

export default class extends Controller {
  connect() {
    autocomplete({
      container: this.element,
      placeholder: 'Search for films',
      autofocus: true,

      getSources() {
        return [
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
            }
          }
        ];
      },
    })
  }
}
