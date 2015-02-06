class AddRetirementDateToStatuses < ActiveRecord::Migration
  def change
    add_column :statuses, :retirement_date, :datetime
  end
end
