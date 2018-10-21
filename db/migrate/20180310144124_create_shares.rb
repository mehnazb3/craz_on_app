class CreateShares < ActiveRecord::Migration[5.1]
  def change
    create_table :shares do |t|
      t.string  :message
      t.integer :status, null: false, default: Constants::Item::Status::OPEN

      t.timestamps
    end

    add_reference :shares, :location, foreign_key: true
    add_reference :shares, :micro_blog, foreign_key: true
    add_reference :shares, :user, foreign_key: true
  end
end
