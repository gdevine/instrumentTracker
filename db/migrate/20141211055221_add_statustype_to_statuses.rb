class AddStatustypeToStatuses < ActiveRecord::Migration
  def change
    add_column :statuses, :statustype, :integer
  end
end
