class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer    :status, default: 0, null: false
      t.belongs_to :group
      t.timestamps
    end

    add_index :games, :status
    add_index :games, :group_id
  end
end
