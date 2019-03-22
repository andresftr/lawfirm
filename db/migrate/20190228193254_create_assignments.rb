# frozen_string_literal: true

class CreateAssignments < ActiveRecord::Migration[5.2]
  def change
    create_table :assignments do |t|
      t.references :affair, foreign_key: true
      t.references :attorney, foreign_key: true

      t.timestamps
    end
  end
end
