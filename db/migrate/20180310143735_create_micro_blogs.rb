class CreateMicroBlogs < ActiveRecord::Migration[5.1]
  def change
    create_table :micro_blogs do |t|
      t.string  :message, null: false, default: ''
      t.integer :status,  null: false, default: Constants::Item::Status::OPEN

      t.timestamps
    end

    add_reference :micro_blogs, :location, foreign_key: true
    add_reference :micro_blogs, :user, foreign_key: true
  end
end
