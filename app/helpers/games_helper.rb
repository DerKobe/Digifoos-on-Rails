module GamesHelper
  def winner_loser_class(team)
    winner_class = 'winner'
    loser_class  = 'loser'
    team.points > 0 ? winner_class : loser_class
  end
end