class CreateAbuses < ActiveRecord::Migration[5.1]
  def change
    create_table :abuses do |t|
      t.string  :reason,            null: false, default: ''
      t.boolean :has_been_handled,  null: false, default: false
      t.boolean :is_confirmed
      t.integer :abusable_item_id
      t.string  :abusable_item_type

      t.timestamps
    end
    add_reference :abuses, :location, foreign_key: true
    add_reference :abuses, :user, foreign_key: true
  end
end
