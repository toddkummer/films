# frozen_string_literal: true

# = Location
class Location < ApplicationRecord
  validates :name, presence: true
end
