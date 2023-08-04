# frozen_string_literal: true

# = Person
class Person < ApplicationRecord
  has_many :roles, class_name: 'PersonRole', dependent: :destroy

  with_options dependent: :destroy do
    has_many :directing_credits
    has_many :writing_credits
    has_many :acting_credits
  end

  PersonRole.roles.each_key do |role|
    predicate = "#{role}?"
    define_method(predicate) do
      roles.any? { |r| r.public_send(predicate) }
    end
  end
end
