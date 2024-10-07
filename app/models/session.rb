# frozen_string_literal: true

# # Session
class Session < ApplicationRecord
  belongs_to :user
end
