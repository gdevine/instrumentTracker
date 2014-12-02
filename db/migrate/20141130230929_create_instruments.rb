class CreateInstruments < ActiveRecord::Migration
  def change
    create_table :instruments do |t|
      t.integer :model_id
      t.string :serialNumber
      t.string :assetNumber
      t.date :purchaseDate
      t.date :retirementDate
      t.string :fundingSource
      t.float :price
      t.string :supplier

      t.timestamps
    end
  end
end
