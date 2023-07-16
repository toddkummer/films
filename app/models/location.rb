# frozen_string_literal: true

# = Location
class Location < ApplicationRecord
  has_many :film_locations, dependent: :destroy
  validates :name, presence: true
end
