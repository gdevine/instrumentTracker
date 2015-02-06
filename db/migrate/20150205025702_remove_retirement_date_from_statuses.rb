class RemoveRetirementDateFromStatuses < ActiveRecord::Migration
  def change
    remove_column :statuses, :retirement_date, :datetime
  end
end
