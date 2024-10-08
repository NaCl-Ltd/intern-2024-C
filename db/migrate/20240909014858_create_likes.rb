class CreateLikes < ActiveRecord::Migration[7.0]
  def change
    create_table :likes do |t|
      t.references :user, null: false, foreign_key: { on_delete: :cascade }
      t.references :likeable, null: false, polymorphic: true

      t.timestamps
    end

    add_index :likes, %i[user_id likeable_type likeable_id], unique: true
  end
end
