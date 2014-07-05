class CreatePlayersAndTeams < ActiveRecord::Migration
  def change

    create_table :players do |t|
      t.string :name
      t.belongs_to :group, null: false, index:true
    end

    create_table :teams do |t|
      t.belongs_to :game, null: false, index:true

      t.integer :goals,  default: 0, null: false
      t.integer :points, default: 0, null: false
    end

    create_table :players_teams do |t|
      t.integer :player_id, null: false, index:true
      t.integer :team_id,   null: false
    end

    add_index :players_teams, [:team_id, :player_id], unique: true
  end
end
