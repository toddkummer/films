# frozen_string_literal: true

module Views
  class Base < Components::Base
    include Components

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

    def container(constraint = nil, &block)
      section(class: 'section') do
        div(class: "container #{constraint}".rstrip, &block)
      end
    end

    def flash_notifications
      return unless flash.any?

      div(class: 'notification is-success') { flash.notice } if flash.notice
      div(class: 'notification is-danger') { flash.alert } if flash.alert
    end
  end
end
