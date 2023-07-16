# frozen_string_literal: true

class CreateFilmLocations < ActiveRecord::Migration[7.0]
  def change
    create_table :film_locations do |t|
      t.references :film, null: false, foreign_key: true
      t.references :location, null: false, foreign_key: true
      t.string :fun_facts

      t.timestamps
    end
  end
end
