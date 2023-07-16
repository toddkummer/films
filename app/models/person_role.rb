# frozen_string_literal: true

# = Person Role
#
# Class PersonRole records the roles for each person: director, writer, or actor.
class PersonRole < ApplicationRecord
  belongs_to :person
  enum :role, %i[director writer actor]
end
