class AddPinnedToMicroposts < ActiveRecord::Migration[7.0]
  def change
    add_column :microposts, :pinned, :boolean, null: false, default: false
  end
end
