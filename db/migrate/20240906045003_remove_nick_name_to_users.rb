class RemoveNickNameToUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :nickname, :string, default: '@'
  end
end
