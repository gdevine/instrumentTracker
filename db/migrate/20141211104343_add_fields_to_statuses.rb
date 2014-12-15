class AddFieldsToStatuses < ActiveRecord::Migration
  def change
    add_column :statuses, :enddate, :datetime
    add_column :statuses, :loaned_to, :string
    add_column :statuses, :address, :text
  end
end
