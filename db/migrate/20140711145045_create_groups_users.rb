class CreateGroupsUsers < ActiveRecord::Migration
  def change
    create_table :groups_users do |t|
      t.integer :user_id, index: true
      t.integer :group_id
    end

    add_index :groups_users, [:user_id, :group_id], unique: true
  end
end
