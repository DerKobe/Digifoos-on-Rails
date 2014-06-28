class PlayersService
  using SqlTrimmer

  class << self
    QUERY = <<-SQL
               SELECT
                 players.*,
                 COALESCE(SUM(teams.goals),  0) AS goals,
                 COALESCE(SUM(teams.points), 0) AS points
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
                 points DESC
    SQL

    def get_players_for(group)
      Player.find_by_sql([QUERY.trim, group.id]).map do |player|
        player.points = player['points']
        player.goals = player['goals']
        player
      end
    end

  end
end
