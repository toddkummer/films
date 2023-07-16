# frozen_string_literal: true

require 'test_helper'

class PersonTest < ActiveSupport::TestCase
  test 'person is a director' do
    person = Person.new
    assert_not_predicate person, :director?

    person.roles.build(role: :director)
    assert_predicate person, :director?
  end
end
