# frozen_string_literal: true

module Views
  module Films
    class Editor < Views::Base
      include Phlex::Rails::Helpers::FormWith

      prop :film, Film, :positional

      def page_title = 'Film'
      def layout = Layout

      def view_template
        container do
          form_with(model: @film, builder: BulmaPhlex::Rails::FormBuilder, data: { turbo: false }) do |form|
            div(class: 'columns') do
              form.text_field :name, icon_left: 'fas fa-ticket', column: 'three-quarters'
              form.number_field :release_year, icon_left: 'fas fa-calendar', column: true
            end

            form.columns do
              form.text_field :name, icon_left: 'fas fa-ticket', column: 'four-fifths'
              form.number_field :release_year, icon_left: 'fas fa-calendar'
            end

            form.grid do
              form.text_field :name, icon_left: 'fas fa-ticket', grid: 'col-span-4'
              form.number_field :release_year, icon_left: 'fas fa-calendar'
            end

            form.fixed_grid do
              form.text_field :name, icon_left: 'fas fa-ticket'
              form.number_field :release_year, icon_left: 'fas fa-calendar'
            end
          end
        end
      end
    end
  end
end
