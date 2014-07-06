module ApplicationHelper
  include BootstrapFlashHelper
  include FontAwesome::Rails::IconHelper

  def current_group
    @group
  end

  def spinner
    fa_icon 'refresh spin'
  end

  def player_link(player)
    link_to player.name, group_player_path(current_group, player)
  end
end
