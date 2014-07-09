module GamesHelper

  def score_badge(team)
    content_tag :div, class: "badge #{team.points > 0 ? 'alert-success' : 'alert-danger'}" do
      if team.points > 0
        "+#{team.points}"
      else
        team.points.to_s
      end
    end
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