class RemoveInstrumentTypeIdFromModels < ActiveRecord::Migration
  def change
    remove_column :models, :instrumentType_id, :integer
  end
end
