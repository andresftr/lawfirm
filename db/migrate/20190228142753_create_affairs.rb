# frozen_string_literal: true

class CreateAffairs < ActiveRecord::Migration[5.2]
  def change
    create_table :affairs do |t|
      t.string :file_number
      t.date :start_date
      t.date :finish_date
      t.string :status
      t.references :client, foreign_key: true

      t.timestamps
    end
  end
end
