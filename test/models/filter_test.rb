# frozen_string_literal: true

require 'test_helper'
require_relative '../../app/models/filter'

class FilterLabelMakerTest < ActiveSupport::TestCase
  def test_location_label
    label = FilterLabelMaker.new('location_id').call(locations(:one).id.to_s)

    assert_equal 'Location: Golden Gate Park', label
  end

  def test_person_label
    label = FilterLabelMaker.new('actor_id').call(people(:one).id.to_s)

    assert_equal 'Actor: Robin Williams', label
  end

  def test_value_not_found
    label = FilterLabelMaker.new('location_id').call('-1')

    assert_equal 'Location: -1', label
  end
end

class FilterTest < ActiveSupport::TestCase
  def test_name_contains_label
    filter = Filter.factory('name', 'bears')

    assert_equal 'Name contains bears', filter.label
    assert_equal 'name', filter.field_name
    assert_equal 'bears', filter.value
  end

  def test_location_label
    location = locations(:one)
    filter = Filter.factory('location_id', location.id.to_s)

    assert_equal 'Location: Golden Gate Park', filter.label
    assert_equal 'location_id', filter.field_name
    assert_equal location.id.to_s, filter.value
  end
end
