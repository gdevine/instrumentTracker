class AddStorageLocationIdToStatuses < ActiveRecord::Migration
  def change
    add_column :statuses, :storage_location_id, :integer
  end
end
