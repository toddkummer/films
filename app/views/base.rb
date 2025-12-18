# frozen_string_literal: true

module Views
  class Base < Components::Base
    include Components

    include Phlex::Rails::Helpers::ButtonTo
    include Phlex::Rails::Helpers::Flash
    include Phlex::Rails::Helpers::TurboFrameTag

    PageInfo = Data.define(:title)

    def around_template
      render layout.new(page_info) do
        main { super }
      end
    end

    def page_info
      PageInfo.new(
        title: page_title
      )
    end

    def container(constraint = nil, &)
      section(class: 'section') do
        div(class: "container #{constraint}".rstrip, &)
      end
    end

    def flash_notifications
      return unless flash.any?

      div(class: 'notification is-success') { flash.notice } if flash.notice
      div(class: 'notification is-danger') { flash.alert } if flash.alert
    end

    def show_field(label, content)
      div(class: 'field') do
        label(class: 'label') { label }
        div(class: 'ml-2') { content }
      end
    end

    def show_list(label, content)
      div(class: 'field') do
        label(class: 'label') { label }

        if content.size > 1
          ul(class: 'mt-1 ml-5') do
            content.each do |item|
              li { item }
            end
          end
        else
          div(class: 'ml-2') { content.first }
        end
      end
    end

    LINK_CONTENT = Data.define(:name, :href)
    def show_links(label, links, none: 'N/A')
      div(class: 'field') do
        label(class: 'label') { label }

        if links.size > 1
          ul(class: 'mt-1 ml-5') do
            links.each do |link|
              li do
                a(href: link.href) { link.name }
              end
            end
          end
        else
          div(class: 'ml-2') do
            if links.empty?
              span { none }
            else
              link = links.first
              a(href: link.href) { link.name }
            end
          end
        end
      end
    end
  end
end
