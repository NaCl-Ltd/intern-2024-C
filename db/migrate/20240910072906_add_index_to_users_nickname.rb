class AddIndexToUsersNickname < ActiveRecord::Migration[7.0]
  def change
    add_index :users, :nickname
  end
end
