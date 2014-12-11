class RemoveEnddatetimeFromServices < ActiveRecord::Migration
  def change
    remove_column :services, :enddatetime, :string
  end
end
