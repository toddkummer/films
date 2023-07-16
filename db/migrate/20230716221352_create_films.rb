# frozen_string_literal: true

class CreateFilms < ActiveRecord::Migration[7.0]
  def change
    create_table :films do |t|
      t.string :name, null: false
      t.integer :release_year, null: false
      t.references :production_company, null: false, foreign_key: { to_table: :companies }
      t.references :distributor, null: false, foreign_key: { to_table: :companies }

      t.timestamps
    end
  end
end
