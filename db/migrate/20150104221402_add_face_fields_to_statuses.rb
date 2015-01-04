class AddFaceFieldsToStatuses < ActiveRecord::Migration
  def change
    add_column :statuses, :ring, :integer
    add_column :statuses, :northing, :float
    add_column :statuses, :easting, :float
    add_column :statuses, :vertical, :float
  end
end
