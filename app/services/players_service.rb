module PlayersService
  using SqlTrimmer

  class Stats < Struct.new(:place, :score, :score_avg, :games_won, :games_lost, :games_won_percentage, :games_lost_percentage, :goals_made, :goals_against, :goals_made_average, :goals_against_average, :big_spoon, :little_spoon, :buddy_ftw, :scores)
  end

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
               SELECT   COALESCE(SUM(teams.points), 0) AS score
               FROM     players_teams INNER JOIN teams ON players_teams.team_id = teams.id
               WHERE    players_teams.player_id = %{player_id}
               GROUP BY players_teams.player_id
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
      ActiveRecord::Base.connection.execute(SCORE_QUERY.trim % { player_id: ActiveRecord::Base.connection.quote(player_id) }).first['score'].to_i
    end

    def get_full_stats_for(player_id)
      # dummy data
      Stats.new(1, 21, 3.2, 12,6, 66.6, 33.3, 230, 198, 5.2, 3.6,
                Player.find(player_id).group.players.all.map{|p| [p,rand(20)] }.shuffle,
                Player.find(player_id).group.players.all.map{|p| [p,rand(20)] }.shuffle,
                Player.find(player_id).group.players.all.map{|p| [p,rand(20)] }.shuffle,
                []
      )
    end
  end
end
