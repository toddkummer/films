# frozen_string_literal: true

module Phlexable
  extend ActiveSupport::Concern

  EDITOR_ACTIONS = %w[
    new
    create
    edit
    update
  ].freeze

  included do
    class_attribute :phlex_views, default: {}
  end

  class_methods do
    def phlex_file_name_for_action(action_name)
      Phlexable::EDITOR_ACTIONS.include?(action_name) ? 'editor' : action_name
    end

    def lookup_phlex_view(action_name)
      file_name = phlex_file_name_for_action(action_name)
      cache_key = [controller_path, file_name]

      (@phlex_views ||= {}).fetch(cache_key) do
        name = ['Views', controller_path, file_name].join('/').camelize
        Rails.logger.debug { "Adding phlex view #{name} to controller cache" }
        @phlex_views[cache_key] = name.constantize
      end
    end
  end

  def phlex(...)
    view = begin
      self.class.lookup_phlex_view(action_name)
    rescue NameError => e
      Rails.logger.error "Could not determine phlex view for #{controller_path} and action #{action_name}: #{e.message}"
      raise "Could not determine phlex view for #{controller_path} and action #{action_name}: #{e.message}"
    end
    view.new(...)
  end
end
