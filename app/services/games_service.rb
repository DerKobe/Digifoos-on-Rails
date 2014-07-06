module GamesService
  class << self

    def open_game_for(group)
      Game.where('group_id = ? AND games.status IN (?,?)', group.id, Game.statuses[:created], Game.statuses[:running]).first unless group.nil?
    end

    def finish_game(game)
      game.update status: :finished
      team1 = game.teams[0]
      team2 = game.teams[1]

      team1.update points: (team1.goals > team2.goals ? 3 : -3)
      team2.update points: (team2.goals > team1.goals ? 3 : -3)
    end

    def inc_goals(team_id)
      team = Team.find(team_id)
      team.update goals: team.goals + 1 if team.goals < 7
    end

    def dec_goals(team_id)
      team = Team.find(team_id)
      team.update goals: team.goals - 1 if team.goals > 0
    end

  end
end