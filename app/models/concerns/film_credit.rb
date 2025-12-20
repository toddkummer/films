# frozen_string_literal: true

# # Film Credit
#
# Mixin FilmCredit provides shared associations and methods for film credit models.
module FilmCredit
  extend ActiveSupport::Concern

  included do
    belongs_to :film
    belongs_to :person

    delegate :name, to: :film, prefix: true
  end
end
