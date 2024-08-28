# frozen_string_literal: true

# # Film
#
class Film < ApplicationRecord
  belongs_to :production_company, class_name: 'Company'
  belongs_to :distributor, class_name: 'Company', optional: true
  has_many :film_locations, dependent: :destroy
  has_one :poster, dependent: :destroy

  with_options dependent: :destroy do
    has_many :directing_credits
    has_many :writing_credits
    has_many :acting_credits
  end

  def self.directed_by(director_id)
    joins(:directing_credits).merge(DirectingCredit.where(person_id: director_id))
  end

  def self.written_by(writer_id)
    joins(:writing_credits).merge(WritingCredit.where(person_id: writer_id))
  end

  def self.acted_by(actor_id)
    joins(:acting_credits).merge(ActingCredit.where(person_id: actor_id))
  end

  validates :name, :release_year, presence: true

  delegate :name, to: :production_company, prefix: true
  delegate :name, to: :distributor, prefix: true, allow_nil: true

  def directors
    directing_credits.map(&:person)
  end

  def writers
    writing_credits.map(&:person)
  end

  def actors
    acting_credits.map(&:person)
  end

  def location_names
    film_locations.map(&:location).map(&:name)
  end
end
