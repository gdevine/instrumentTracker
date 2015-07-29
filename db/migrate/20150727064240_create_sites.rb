class CreateSites < ActiveRecord::Migration
  def change
    create_table :sites do |t|
      t.string :name
      t.string :shortname
      t.text :address
      t.text :description
      t.string :contact
      t.string :website

      t.timestamps
    end
  end
end
