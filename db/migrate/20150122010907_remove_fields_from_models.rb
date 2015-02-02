class RemoveFieldsFromModels < ActiveRecord::Migration
  def change
    remove_column :models, :manufacturer, :string
    remove_column :models, :modelType, :string
  end
end
