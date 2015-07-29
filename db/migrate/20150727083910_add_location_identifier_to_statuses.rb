class AddLocationIdentifierToStatuses < ActiveRecord::Migration
  def change
    add_column :statuses, :location_identifier, :string
  end
end
