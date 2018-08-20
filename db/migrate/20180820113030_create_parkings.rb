class CreateParkings < ActiveRecord::Migration[5.1]
  def change
    create_table :parkings do |t|
      t.string :license
      t.decimal :price
      t.integer :validity
      t.boolean :is_void

      t.timestamps
    end
  end
end
