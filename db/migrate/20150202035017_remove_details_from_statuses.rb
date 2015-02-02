class RemoveDetailsFromStatuses < ActiveRecord::Migration
  def change
    remove_column :statuses, :details, :text
  end
end
