class ChangeDefaultadminInUsers < ActiveRecord::Migration
  def up
    change_column :users, :admin, :boolean, :default => false
    change_column :users, :approved, :boolean, :default => false
  end
end
