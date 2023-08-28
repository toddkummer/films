# frozen_string_literal: true

# = Film
class Film < ApplicationRecord
  belongs_to :production_company, class_name: 'Company'
  belongs_to :distributor, class_name: 'Company', optional: true
  has_many :film_locations, dependent: :destroy

  scope :directed_by, ->(director_id) { joins(:directing_credits).merge(DirectingCredit.where(person_id: director_id)) }
  scope :written_by, ->(writer_id) { joins(:writing_credits).merge(WritingCredit.where(person_id: writer_id)) }
  scope :acted_by, ->(actor_id) { joins(:acting_credits).merge(ActingCredit.where(person_id: actor_id)) }

  with_options dependent: :destroy do
    has_many :directing_credits
    has_many :writing_credits
    has_many :acting_credits
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
end
