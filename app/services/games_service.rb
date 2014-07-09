module GamesService
  class << self

    def open_game_for(group)
      Game.where('group_id = ? AND games.status IN (?,?)', group.id, Game.statuses[:created], Game.statuses[:running]).first unless group.nil?
    end

    def finish_game(game)
      raise 'Game already finished' if game.finished?

      game.update status: :finished

      team1 = game.teams[0]
      team2 = game.teams[1]

      (winners, losers) = team1.goals > team2.goals ? [team1, team2] : [team2, team1]

      winners.update points: elo(score(winners), score(losers), true)
      losers.update  points: elo(score(losers), score(winners), false)
    end

    def inc_goals(team_id)
      team = Team.find(team_id)
      team.update goals: team.goals + 1 if team.goals < 7
    end

    def dec_goals(team_id)
      team = Team.find(team_id)
      team.update goals: team.goals - 1 if team.goals > 0
    end

    private

    def elo(ra, rb, team_won, f = 150)
      ra + ( 15.0 * ( (team_won ? 1 : 0) - ( 1.0 / ( 1.0 + (10 ** ((rb - ra) / f )))))).to_i
    end

    def score(team)
      @score ||= {}
      @score[team.id] ||= team.players.reduce(0) do |score, player|
        score + PlayersService.get_score_for(player.id)
      end
    end

  end
end