module PlayersService
  using SqlTrimmer

  class Stats < Struct.new(:place, :score, :games_played, :games_won, :games_lost, :games_won_percentage, :games_lost_percentage, :goals_made, :goals_against, :goals_made_average, :goals_against_average, :buddy_ftw, :banana_buddy, :big_spoon, :little_spoon, :scores); end
  
  class << self
    GET_PLAYERS_QUERY = <<-SQL
               SELECT
                 players.*,
                 COALESCE(SUM(teams.goals), 0)  AS goals,
                 SUM(teams.points) AS points,
                 (SELECT COUNT(*) FROM players_teams WHERE player_id=players.id) AS games_played
               FROM
                 players
                 LEFT JOIN players_teams ON players_teams.player_id = players.id
                 LEFT JOIN teams         ON teams.id = players_teams.team_id
                 LEFT JOIN games         ON teams.game_id = games.id
               WHERE
                 players.group_id = ? AND points IS NOT NULL
               GROUP BY
                 players.id
               ORDER BY
                 points DESC, goals DESC, games_played DESC, players.id ASC
               LIMIT ?
    SQL
    .trim

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
    .trim

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
    .trim

    BUDDY_QUERY = <<-SQL
               SELECT
                 players_teams.player_id,
                 COUNT(teams.id) AS number_of_games
               FROM
                 teams
                 INNER JOIN players_teams ON teams.id = players_teams.team_id AND players_teams.player_id != %{player_id}
               WHERE
                 teams.id IN (SELECT team_id FROM players_teams WHERE player_id = %{player_id})
                 AND
                 teams.points %{comp} 0
               GROUP BY
                 players_teams.player_id
               ORDER BY
                 number_of_games DESC
    SQL
    .trim

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
    .trim

    def get_players_for(group, limit = 100)
      Player.find_by_sql([GET_PLAYERS_QUERY, group.id, limit]).map do |player|
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
      ActiveRecord::Base.connection.execute(SCORE_QUERY % { player_id: ActiveRecord::Base.connection.quote(player_id) }).first['score'].to_i
    end

    def get_full_stats_for(player)
      place = get_players_for(player.group).index(player) + 1

      stats         = execute(SCORE_QUERY         % { player_id: quote(player.id) }).first
      goals_against = execute(GOALS_AGAINST_QUERY % { player_id: quote(player.id) }).first['goals_against'].to_i
      buddy_ftw     = execute(BUDDY_QUERY         % { player_id: quote(player.id), comp: '>' }).to_a
      banana_budy   = execute(BUDDY_QUERY         % { player_id: quote(player.id), comp: '<' }).to_a
      little_spoon  = execute(SPOON_QUERY         % { player_id: quote(player.id), comp: '>' }).to_a
      big_spoon     = execute(SPOON_QUERY         % { player_id: quote(player.id), comp: '<' }).to_a

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
          banana_budy,
          little_spoon,
          big_spoon,
          []
      )
    end

    private

    def execute(*args) ActiveRecord::Base.connection.execute *args  end
    def quote(*args)   ActiveRecord::Base.connection.quote   *args  end
  end
end