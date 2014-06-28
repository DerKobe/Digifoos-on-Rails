class CreatePlayersAndTeams < ActiveRecord::Migration
  def change

    create_table :players do |t|
      t.string :name
      t.belongs_to :group, null: false
    end

    create_table :teams do |t|
      t.belongs_to :game, null: false

      t.integer :goals,  default: 0, null: false
      t.integer :points, default: 0, null: false
    end

    create_table :players_teams do |t|
      t.belongs_to :player, null: false
      t.belongs_to :team,   null: false
    end

    add_index :players,       :group_id
    add_index :teams,         :game_id
    add_index :players_teams, :player_id
    add_index :players_teams, :team_id
  end
end
