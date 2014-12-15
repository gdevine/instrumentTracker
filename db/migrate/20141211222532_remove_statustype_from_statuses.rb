class RemoveStatustypeFromStatuses < ActiveRecord::Migration
  def change
    remove_column :statuses, :statustype, :integer
  end
end
