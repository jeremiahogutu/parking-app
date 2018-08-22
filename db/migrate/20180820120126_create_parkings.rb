class CreateParkings < ActiveRecord::Migration[5.1]
  def change
    create_table :parkings do |t|

      t.timestamps
    end
  end
end
