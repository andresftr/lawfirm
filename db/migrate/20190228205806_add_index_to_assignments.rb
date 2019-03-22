# frozen_string_literal: true

class AddIndexToAssignments < ActiveRecord::Migration[5.2]
  def change
    add_index :assignments, %i[affair_id attorney_id], unique: true
  end
end
