class AddInstModelIndex < ActiveRecord::Migration
  def change
    add_index :instruments, [:model_id, :created_at]
  end
end
