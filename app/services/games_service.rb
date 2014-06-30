module GamesService
  class << self

    def open_game_for(group)
      Game.where('group_id = ? AND games.status IN (?,?)', group.id, Game.statuses[:created], Game.statuses[:running]).first
    end

  end
end