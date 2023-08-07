# frozen_string_literal: true

class ChangeDistributorToOptional < ActiveRecord::Migration[7.0]
  def change
    change_column_null :films, :distributor_id, true
  end
end
