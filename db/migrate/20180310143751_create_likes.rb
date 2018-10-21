class CreateLikes < ActiveRecord::Migration[5.1]
  def change
    create_table :likes do |t|
      t.integer :status,            null: false, default: Constants::Item::Status::OPEN
      t.integer :likable_item_id
      t.string  :likable_item_type

      t.timestamps
    end
    add_reference :likes, :location, foreign_key: true
    add_reference :likes, :user, foreign_key: true
  end
end
