class AddIsblockedToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :isblocked, :boolean
  end
end
