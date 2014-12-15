class AddReporterIdToStatuses < ActiveRecord::Migration
  def change
    add_column :statuses, :reporter_id, :integer
  end
end
