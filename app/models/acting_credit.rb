# frozen_string_literal: true

# = Acting Credit
#
# Class ActingCredit lists the films an actor has appeared in.
class ActingCredit < ApplicationRecord
  belongs_to :film
  belongs_to :person
end
