class RemoveCurrentFromStatuses < ActiveRecord::Migration
  def change
    remove_column :statuses, :current, :boolean
  end
end
