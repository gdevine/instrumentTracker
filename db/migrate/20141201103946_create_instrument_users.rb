class CreateInstrumentUsers < ActiveRecord::Migration
  def change
    create_table :instrument_users do |t|
      t.integer :instrument_id
      t.integer :user_id
      t.string :role

      t.timestamps
    end
  end
end
