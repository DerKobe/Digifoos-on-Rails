module GamesHelper

  def winner_loser_class(team)
    winner_class = 'winner'
    loser_class  = 'loser'
    team.points > 0 ? winner_class : loser_class
  end

  def date_indicator(game)
    if @last_timestamp.try(:at_beginning_of_day) != game.created_at.at_beginning_of_day
      @last_timestamp = game.created_at.at_beginning_of_day

      content_tag :tr, class: 'date-indicator' do
        content_tag :td, colspan: 3 do
          l @last_timestamp.to_date, format: :long
        end
      end
    end
  end
end