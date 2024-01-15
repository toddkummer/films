# frozen_string_literal: true

# = Filter Label Maker
class FilterLabelMaker
  TYPES_OF_PEOPLE = %w[Actor Director Writer].freeze

  def initialize(field_name)
    @prefix = field_name.delete_suffix('_id').titleize
    @model = TYPES_OF_PEOPLE.include?(@prefix) ? Person : @prefix.constantize
  end

  def call(id)
    "#{@prefix}: #{instance_name(id)}"
  end

  private

  def instance_name(id)
    @model.find(id).name
  rescue ActiveRecord::RecordNotFound
    id
  end
end

# = Filter
class Filter
  include ActiveModel::API

  attr_accessor :label, :field_name, :value

  class << self
    def factory(field_name, value)
      label = label_builders[field_name].call(value)
      new(field_name: field_name, value: value, label: label)
    end

    private

    def label_builders
      @label_builders ||= { 'name' => ->(value) { "Name contains #{value}" } }.tap do |h|
        h.default_proc = proc { |hash, key| hash[key] = FilterLabelMaker.new(key) }
      end
    end
  end
end
