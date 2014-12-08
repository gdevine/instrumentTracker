class CreateServices < ActiveRecord::Migration
  def change
    create_table :services do |t|
      t.integer :instrument_id
      t.text :problem
      t.text :comments
      t.integer :reporter_id
      t.datetime :startdatetime
      t.string :enddatetime
      t.datetime :reporteddate

      t.timestamps
    end
    add_index :services, [:instrument_id, :created_at]
  end
end
