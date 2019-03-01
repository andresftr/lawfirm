class CreateAttorneys < ActiveRecord::Migration[5.2]
  def change
    create_table :attorneys do |t|
      t.string :dni
      t.string :full_name
      t.string :address
      t.string :nacionality

      t.timestamps
    end
  end
end
