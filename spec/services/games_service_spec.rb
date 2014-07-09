require 'spec_helper'

RSpec.describe GamesService do

  describe '#get_players_for' do
    context 'elo points' do
      let(:group) { FactoryGirl.create(:group) }
      let(:players) do
        [
            FactoryGirl.create(:player, group: group, name: 'Richard'),
            FactoryGirl.create(:player, group: group, name: 'Irenäus'),
            FactoryGirl.create(:player, group: group, name: 'Alexander'),
            FactoryGirl.create(:player, group: group, name: 'Christoph'),
            FactoryGirl.create(:player, group: group, name: 'Philip'),
        ]
      end

      def create_game(pl1, pl2, pl3, pl4, g1, g2)
        game = FactoryGirl.create(:game, status: 1)
        game.teams << FactoryGirl.create(:team, game: game, players: [players[pl1], players[pl2]], goals: g1)
        game.teams << FactoryGirl.create(:team, game: game, players: [players[pl3], players[pl4]], goals: g2)
        game
      end

      it 'example 1' do
        game = create_game 0,1,2,3, 5,3

        GamesService.finish_game(game)

        #binding.pry
      end

    end
  end

end
