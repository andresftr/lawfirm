# frozen_string_literal: true

class CreateClients < ActiveRecord::Migration[5.2]
  def change
    create_table :clients do |t|
      t.string :dni
      t.string :full_name
      t.string :address
      t.string :nacionality
      t.date :birthdate

      t.timestamps
    end
  end
end
