# frozen_string_literal: true

class CreatePosters < ActiveRecord::Migration[7.0]
  def change
    create_table :posters do |t|
      t.references :film, null: false, foreign_key: true
      t.string :filename, null: false
      t.timestamps
    end
  end
end
