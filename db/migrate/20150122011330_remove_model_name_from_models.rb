class RemoveModelNameFromModels < ActiveRecord::Migration
  def change
    remove_column :models, :modelName, :string
  end
end
