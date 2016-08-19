class ChangeTableName < ActiveRecord::Migration
  def change
    rename_table :tweets, :dinos
    rename_table :users, :tweets
    rename_table :dinos, :users
  end
end
