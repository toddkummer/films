# frozen_string_literal: true

# = Person
class Person < ApplicationRecord
  has_many :roles, class_name: 'PersonRole', dependent: :destroy

  PersonRole.roles.each_key do |role|
    predicate = "#{role}?"
    define_method(predicate) do
      roles.any? { |r| r.public_send(predicate) }
    end
  end
end
