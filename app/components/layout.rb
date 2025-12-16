# frozen_string_literal: true

module Components
  # Layout for Phlex views
  class Layout < Components::Base
    include Phlex::Rails::Helpers::CSRFMetaTags
    include Phlex::Rails::Helpers::CSPMetaTag
    include Phlex::Rails::Helpers::JavascriptImportmapTags
    include Phlex::Rails::Helpers::StylesheetLinkTag

    def initialize(page_info)
      @page_info = page_info
    end

    def view_template(&block)
      doctype

      html do
        head do
          title { @page_info.title }

          meta name: 'viewport', content: 'width=device-width, initial-scale=1'
          meta name: 'apple-mobile-web-app-capable', content: 'yes'
          meta name: 'mobile-web-app-capable', content: 'yes'

          csrf_meta_tags
          csp_meta_tag

          javascript_importmap_tags
          stylesheets
        end

        body(&block)
      end
    end

    private

    def stylesheets
      link rel: 'stylesheet',
           href: 'https://cdn.jsdelivr.net/npm/bulma@1.0.4/css/bulma.min.css'
      link rel: 'stylesheet',
           href: 'https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css',
           integrity: 'sha512-Kc323vGBEqzTmouAECnVceyQqyqdsSiqLQISBL29aUW4U/M7pSPA/gEUZQqv1cwx4OnYxTxve5UMg5GT6L4JJg==',
           crossorigin: 'anonymous',
           referrerpolicy: 'no-referrer'
      link rel: 'stylesheet',
           href: 'https://cdn.jsdelivr.net/npm/@algolia/autocomplete-theme-classic'

      stylesheet_link_tag :app, 'data-turbo-track': 'reload'
    end
  end
end
