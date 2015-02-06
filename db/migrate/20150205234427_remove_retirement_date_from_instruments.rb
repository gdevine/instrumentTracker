class RemoveRetirementDateFromInstruments < ActiveRecord::Migration
  def change
    remove_column :instruments, :retirementDate, :date
  end
end
