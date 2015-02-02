class AddInstrumentTypeIdToModels < ActiveRecord::Migration
  def change
    add_column :models, :instrument_type_id, :integer
  end
end
