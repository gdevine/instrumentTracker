class AddSiteIdToStatuses < ActiveRecord::Migration
  def change
    add_column :statuses, :site_id, :integer
  end
end
