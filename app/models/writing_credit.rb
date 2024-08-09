# frozen_string_literal: true

# # Writing Credit
#
# Class WritingCredit lists the films an writer has authored.
class WritingCredit < ApplicationRecord
  belongs_to :film
  belongs_to :person
end
