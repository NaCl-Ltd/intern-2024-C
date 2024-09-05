class RemoveintroductionFromusers < ActiveRecord::Migration[7.0]
  def up
    remove_column :users, :introduction ,:string
  end

  def down
    add_column :users, :introduction, :string, default:''

  end
end