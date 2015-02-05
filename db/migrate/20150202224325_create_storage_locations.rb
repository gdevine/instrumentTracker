class CreateStorageLocations < ActiveRecord::Migration
  def change
    create_table :storage_locations do |t|
      t.string :code
      t.string :room
      t.string :building
      t.text :address
      t.text :comments

      t.timestamps
    end
  end
end
