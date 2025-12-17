# frozen_string_literal: true

module Components
  # # Poster
  #
  # This shows a film poster image wrapped in a DOM id.
  class Poster < Components::Base
    prop :poster, ::Poster, :positional
    prop :width, Integer, default: 500

    def view_template
      div(id: dom_id(@poster)) do
        img src: @poster.url(@width)
      end
    end
  end
end
