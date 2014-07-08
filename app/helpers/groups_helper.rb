module GroupsHelper
  include GamesHelper

  def group_stats(group)
    if group.games.any?
      content_tag :span, class: 'players' do
        PlayersService.get_players_for(group, 10).keep_if{|p| p.games_played > 0}[0..2].collect.with_index do |player, index|
          concat(
              content_tag(:span, class: "position-#{index+1} trophy") do
                fa_stacked_icon 'trophy inverse', base: 'circle', class: "trophy position-#{index+1}", text: player.name
              end
          )
        end
      end
    end
  end
end