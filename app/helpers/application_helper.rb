module ApplicationHelper
  include BootstrapFlashHelper
  include FontAwesome::Rails::IconHelper

  def current_group
    @group
  end

  def spinner
    fa_icon 'refresh spin'
  end

  def player_link(player_id)
    name = if @players.present?
             @players.select{ |player| player.id == player_id }.first.name
           else
             Player.find(player_id).name
           end

    link_to name, group_player_path(current_group, player_id)
  end
end
