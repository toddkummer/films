# frozen_string_literal: true

# = Company
class Company < ApplicationRecord
  with_options class_name: 'Film', dependent: :destroy do
    has_many :film_productions, inverse_of: :production_company, foreign_key: :production_company_id
    has_many :film_distributions, inverse_of: :distributor, foreign_key: :distributor_id
  end
end
