class AddFieldsToModels < ActiveRecord::Migration
  def change
    add_column :models, :manufacturer_id, :integer
    add_column :models, :instrumentType_id, :integer
    add_column :models, :name, :string
    add_column :models, :details, :text
  end
end
