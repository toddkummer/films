# frozen_string_literal: true

# = Film
class Film < ApplicationRecord
  belongs_to :production_company, class_name: 'Company'
  belongs_to :distributor, class_name: 'Company', optional: true
  has_many :film_locations, dependent: :destroy

  with_options dependent: :destroy do
    has_many :directing_credits
    has_many :writing_credits
    has_many :acting_credits
  end

  validates :name, :release_year, presence: true

  delegate :name, to: :production_company, prefix: true
  delegate :name, to: :distributor, prefix: true
end
