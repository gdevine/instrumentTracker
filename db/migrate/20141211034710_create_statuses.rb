class CreateStatuses < ActiveRecord::Migration
  def change
    create_table :statuses do |t|
      t.datetime :startdate
      t.boolean :current, :default => false, :null => false
      t.integer :instrument_id
      t.text :content
      t.text :comments

      t.timestamps
    end
    
    add_index :statuses, [:instrument_id, :created_at]
  end
end
