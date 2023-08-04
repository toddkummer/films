# frozen_string_literal: true

class CreateActingCredits < ActiveRecord::Migration[7.0]
  def change
    create_table :acting_credits do |t|
      t.references :film, null: false, foreign_key: true
      t.references :person, null: false, foreign_key: true

      t.timestamps
    end
  end
end
