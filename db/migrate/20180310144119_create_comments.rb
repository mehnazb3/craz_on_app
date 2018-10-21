class CreateComments < ActiveRecord::Migration[5.1]
  def change
    create_table :comments do |t|
      t.string  :message,               null: false, default: ''
      t.integer :status,                null: false, default: Constants::Item::Status::OPEN
      t.integer :commentable_item_id
      t.string  :commentable_item_type
      t.boolean :is_a_reply,            null: false, default: false

      t.timestamps
    end

    add_reference :comments, :location, foreign_key: true
    add_reference :comments, :user, foreign_key: true
  end
end
