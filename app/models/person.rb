# frozen_string_literal: true

# # Person
class Person < ApplicationRecord
  has_many :roles, class_name: 'PersonRole', dependent: :destroy

  with_options dependent: :destroy do
    has_many :directing_credits
    has_many :writing_credits
    has_many :acting_credits
  end

  scope :director, -> { joins(:roles).merge(PersonRole.director) }
  scope :writer, -> { joins(:roles).merge(PersonRole.writer) }
  scope :actor, -> { joins(:roles).merge(PersonRole.actor) }

  PersonRole.roles.each_key do |role|
    predicate = "#{role}?"
    define_method(predicate) do
      roles.any? { |r| r.public_send(predicate) }
    end
  end

  def to_s
    name
  end
end
