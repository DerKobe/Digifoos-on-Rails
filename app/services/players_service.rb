class PlayersService
  class << self

    QUERY_POINTS = <<-SQL
               SELECT
                 (SUM(points_team1) + SUM(points_team1)) AS points
               FROM
                 games
               WHERE
                 group_id = ?
                 AND
                 (
                   (player1_id = ? OR player2_id = ?) AND points_team1 > points_team2
                   OR
                   (player3_id = ? OR player4_id = ?) AND points_team1 < points_team2
                 )
    SQL

    QUERY_GOALS = <<-SQL.strip_heredoc
               SELECT
                 SUM(CASE WHEN player1_id = ? OR player2_id = ? THEN goals_team1 ELSE goals_team2 END) AS goals_made,
                 SUM(CASE WHEN player3_id = ? OR player4_id = ? THEN goals_team1 ELSE goals_team2 END) AS goals_against
               FROM
                 games
               WHERE
                 group_id = ? AND ( player1_id = ? OR player2_id = ? OR player3_id = ? OR player4_id = ? )
    SQL

    def get_players_for(group)
      group.players.map do |player|
        player.points = ActiveRecord::Base.connection.select_all(ActiveRecord::Base.send(:sanitize_sql_array,[QUERY_POINTS, group.id, player.id, player.id, player.id, player.id])).first['points'].to_i
        result = ActiveRecord::Base.connection.select_all(ActiveRecord::Base.send(:sanitize_sql_array,[QUERY_GOALS, player.id, player.id, player.id, player.id, group.id, player.id, player.id, player.id, player.id])).first
        player.goals_made = result['goals_made'].to_i
        player.goals_against = result['goals_against'].to_i
        player
      end.sort_by{ |p| -p.points }.reduce([]) do |players, player|
        player.position = players.empty? ? 1 : players.last.position + 1
        players << player
        players
      end
    end

  end
end