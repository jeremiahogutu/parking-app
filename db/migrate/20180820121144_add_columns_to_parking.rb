class AddColumnsToParking < ActiveRecord::Migration[5.1]
  def change
    add_column :parkings, :license, :string
    add_column :parkings, :price, :decimal
    add_column :parkings, :validity, :integer
    add_column :parkings, :is_void, :boolean, default: false
  end
end
