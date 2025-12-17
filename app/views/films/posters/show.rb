# frozen_string_literal: true

module Views
  module Films
    module Posters
      class Show < Views::Base
        prop :poster, ::Poster, :positional
        prop :width, Integer

        def page_title = 'Poster'
        def layout = Layout

        def view_template
          div do
            turbo_frame_tag 'poster' do
              Poster(@poster, width: @width)
            end
          end
        end
      end
    end
  end
end
