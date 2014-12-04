class CreateModels < ActiveRecord::Migration
  def change
    create_table :models do |t|
      t.string :modelType
      t.string :manufacturer
      t.string :modelName

      t.timestamps
    end
  end
end
