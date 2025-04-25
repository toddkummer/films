import { Application } from "@hotwired/stimulus"
import * as SearchSources from '../src/search_sources'

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

// Add search sources to the Stimulus application
application.quickSearchSources = SearchSources

export { application }
