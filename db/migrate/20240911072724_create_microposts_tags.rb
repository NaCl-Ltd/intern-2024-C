class CreateMicropostsTags < ActiveRecord::Migration[7.0]
  def change
    create_table :microposts_tags, id: false do |t|
      t.references :micropost
      t.references :tag
    end
  end
end
