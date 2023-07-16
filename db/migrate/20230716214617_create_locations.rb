# frozen_string_literal: true

class CreateLocations < ActiveRecord::Migration[7.0]
  def change
    create_table :locations do |t|
      t.string :name, null: false
      t.integer :find_neighborhood_id
      t.string :analysis_neighborhood_id
      t.integer :supervisor_district_id

      t.timestamps
    end
  end
end
