class RemoveStorageLocationFromStatuses < ActiveRecord::Migration
  def change
    remove_column :statuses, :storage_location, :text
  end
end
