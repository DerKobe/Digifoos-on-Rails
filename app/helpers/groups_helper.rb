module GroupsHelper
  include GamesHelper

  def group_stats(group)
    if group.games.any?
      content_tag :span, class: 'players' do
        PlayersService.get_players_for(group, 3).collect.with_index do |player, index|
          concat(
              content_tag(:span, class: "position-#{index} trophy") do
                fa_stacked_icon 'trophy inverse', base: 'circle', class: "trophy position-#{index}", text: player.name
              end
          )
        end
      end
    end
  end
end