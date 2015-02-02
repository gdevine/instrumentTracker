class AddStorageVarsToStatuses < ActiveRecord::Migration
  def change
    add_column :statuses, :storage_location, :text
    add_column :statuses, :details, :text
  end
end
