class Defaultrole < ActiveRecord::Migration
  def change
    change_column_default :instrument_users, :role, 'owner'
  end
end
