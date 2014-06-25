class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :player1_id
      t.integer :player2_id
      t.integer :player3_id
      t.integer :player4_id

      t.integer :goals_team1, defaul: 0
      t.integer :goals_team2, defaul: 0

      t.integer :points_team1, defaul: 0
      t.integer :points_team2, defaul: 0

      t.belongs_to :group

      t.timestamps
    end
  end
end
