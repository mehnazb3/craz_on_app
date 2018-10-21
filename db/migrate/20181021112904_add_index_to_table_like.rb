class AddIndexToTableLike < ActiveRecord::Migration[5.1]
  def change
    add_index :likes, [:likable_item_id, :likable_item_type, :user_id], unique: true, name: 'unique_like'
  end
end
