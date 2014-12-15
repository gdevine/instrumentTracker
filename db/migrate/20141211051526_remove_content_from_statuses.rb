class RemoveContentFromStatuses < ActiveRecord::Migration
  def change
    remove_column :statuses, :content, :text
  end
end
