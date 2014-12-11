class AddEnddatetimeToServices < ActiveRecord::Migration
  def change
    add_column :services, :enddatetime, :datetime
  end
end
