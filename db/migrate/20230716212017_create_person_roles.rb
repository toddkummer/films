# frozen_string_literal: true

class CreatePersonRoles < ActiveRecord::Migration[7.0]
  def change
    create_table :person_roles do |t|
      t.integer :role
      t.references :person, null: false, foreign_key: true

      t.timestamps
    end
  end
end
