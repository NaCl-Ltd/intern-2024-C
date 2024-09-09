class AddLikesCountToMicroposts < ActiveRecord::Migration[7.0]
  def change
    add_column :microposts, :likes_count, :integer, null: false, default: 0

    up_only do
      Micropost.find_each do |a|
        Micropost.reset_counters(a.id, :likes)
      end
    end
  end
end
