# frozen_string_literal: true

# # Film Location
class FilmLocation < ApplicationRecord
  belongs_to :film
  belongs_to :location
end
