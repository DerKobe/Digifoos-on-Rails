module PlayersService
  using SqlTrimmer

  class << self
    GET_PLAYERS_QUERY = <<-SQL
               SELECT
                 players.*,
                 COALESCE(SUM(teams.goals), 0)  AS goals,
                 COALESCE(SUM(teams.points), 0) AS points,
                 (SELECT COUNT(*) FROM players_teams WHERE player_id=players.id) AS games_played
               FROM
                 players
                 LEFT JOIN players_teams ON players_teams.player_id = players.id
                 LEFT JOIN teams         ON teams.id = players_teams.team_id
                 LEFT JOIN games         ON teams.game_id = games.id
               WHERE
                 players.group_id = ?
               GROUP BY
                 players.id
               ORDER BY
                 points DESC, goals DESC, games_played DESC, players.id ASC
               LIMIT ?
    SQL

    SCORE_QUERY = <<-SQL
               SELECT
                 COALESCE(SUM(teams.points), 0) AS points
               FROM
                 players
                 INNER JOIN players_teams ON players_teams.player_id = players.id
                 INNER JOIN teams         ON teams.id = players_teams.team_id
               WHERE
                 players.id = %{player_id}
               GROUP BY
                 players.id
    SQL

    def get_players_for(group, limit = 100)
      Player.find_by_sql([GET_PLAYERS_QUERY.trim, group.id, limit]).map do |player|
        player.points        = player['points']
        player.goals         = player['goals']
        player.games_played  = player['games_played']
        player
      end
    end

    def played_already?(player_id)
      ActiveRecord::Base.connection.execute("SELECT 1 FROM players_teams WHERE player_id = #{ActiveRecord::Base.connection.quote player_id} LIMIT 1").first.present?
    end

    def get_score_for(player_id)
      ActiveRecord::Base.connection.execute(SCORE_QUERY % { player_id: ActiveRecord::Base.connection.quote(player_id) }).first['points'].to_i
    end
  end
end
