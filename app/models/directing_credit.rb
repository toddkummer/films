# frozen_string_literal: true

# = Directing Credit
#
# Class DirectingCredit lists the films director has made.
class DirectingCredit < ApplicationRecord
  belongs_to :film
  belongs_to :person
end
