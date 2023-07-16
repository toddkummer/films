# frozen_string_literal: true

# = Film
class Film < ApplicationRecord
  belongs_to :production_company, class_name: 'Company'
  belongs_to :distributor, class_name: 'Company'
  has_many :film_locations, dependent: :destroy
  validates :name, :release_year, presence: true
end
