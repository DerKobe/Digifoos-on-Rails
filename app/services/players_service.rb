module PlayersService
  using SqlTrimmer

  class Stats < Struct.new(:place, :score, :games_played, :games_won, :games_lost, :games_won_percentage, :games_lost_percentage, :goals_made, :goals_against, :goals_made_average, :goals_against_average, :buddy_ftw, :big_spoon, :little_spoon, :scores); end
  
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
                 COALESCE(SUM(teams.points), 0) AS score,
                 COUNT(teams.points) AS games_played,
                 COALESCE(SUM(CASE WHEN teams.points > 0 THEN 1 ELSE 0 END), 0) AS games_won,
                 COALESCE(SUM(teams.goals), 0) AS goals_made
               FROM
                 players_teams INNER JOIN teams ON players_teams.team_id = teams.id
               WHERE
                 players_teams.player_id = %{player_id}
    SQL

    GOALS_AGAINST_QUERY = <<-SQL
               SELECT
                 SUM(teams.goals) AS goals_against
               FROM
                 games
                 INNER JOIN teams ON games.id = teams.game_id
               WHERE
                 games.id IN (SELECT teams.game_id FROM teams INNER JOIN players_teams ON teams.id = players_teams.team_id WHERE players_teams.player_id = %{player_id})
                 AND
                 teams.id NOT IN (SELECT team_id FROM players_teams WHERE player_id = %{player_id})
    SQL

    BUDDY_FTW_QUERY = <<-SQL
               SELECT
                 players_teams.player_id,
                 COUNT(teams.id) AS number_of_games
               FROM
                 teams
                 INNER JOIN players_teams ON teams.id = players_teams.team_id AND players_teams.player_id != %{player_id}
               WHERE
                 teams.id IN (SELECT team_id FROM players_teams WHERE player_id = %{player_id})
                 AND
                 teams.points > 0
               GROUP BY
                 players_teams.player_id
               ORDER BY
                 number_of_games DESC
    SQL

    SPOON_QUERY = <<-SQL
               SELECT
                 players_teams.player_id,
                 COUNT(games.id) AS number_of_games
               FROM
                 games
                 INNER JOIN teams         ON games.id = teams.game_id
                 INNER JOIN players_teams ON teams.id = players_teams.team_id
               WHERE
                 games.id IN (SELECT teams.game_id FROM teams INNER JOIN players_teams ON teams.id = players_teams.team_id WHERE players_teams.player_id = %{player_id})
                 AND
                 teams.id NOT IN (SELECT team_id FROM players_teams WHERE player_id = %{player_id})
                 AND
                 teams.points %{comp} 0
               GROUP BY
                 players_teams.player_id
               ORDER BY
                 number_of_games DESC
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

    def get_full_stats_for(player)
      place = get_players_for(player.group).index(player) + 1

      stats         = ActiveRecord::Base.connection.execute(SCORE_QUERY.trim         % { player_id: ActiveRecord::Base.connection.quote(player.id) }).first
      goals_against = ActiveRecord::Base.connection.execute(GOALS_AGAINST_QUERY.trim % { player_id: ActiveRecord::Base.connection.quote(player.id) }).first['goals_against'].to_i
      buddy_ftw     = ActiveRecord::Base.connection.execute(BUDDY_FTW_QUERY.trim     % { player_id: ActiveRecord::Base.connection.quote(player.id) }).to_a
      little_spoon  = ActiveRecord::Base.connection.execute(SPOON_QUERY.trim         % { player_id: ActiveRecord::Base.connection.quote(player.id), comp: '>' }).to_a
      big_spoon     = ActiveRecord::Base.connection.execute(SPOON_QUERY.trim         % { player_id: ActiveRecord::Base.connection.quote(player.id), comp: '<' }).to_a

      Stats.new(
          place,
          stats['score'],
          stats['games_played'].to_i,
          stats['games_won'].to_i,
          stats['games_played'].to_i - stats['games_won'].to_i,
          '%.1f' % (stats['games_won'].to_i / (stats['games_played'].to_i * 1.0)*100),
          '%.1f' % ((stats['games_played'].to_i - stats['games_won'].to_i) / (stats['games_played'].to_i * 1.0)*100),
          stats['goals_made'].to_i,
          goals_against,
          '%.1f' % (stats['goals_made'].to_i / (stats['games_played'].to_i * 1.0)),
          '%.1f' % (goals_against / (stats['games_played'].to_i * 1.0)),
          buddy_ftw,
          little_spoon,
          big_spoon,
          []
      )
    end
  end
end