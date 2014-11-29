class AddFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :admin, :boolean
    add_column :users, :approved, :boolean
    add_column :users, :firstname, :string
    add_column :users, :surname, :string
  end
end
