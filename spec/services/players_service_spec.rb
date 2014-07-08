require 'spec_helper'

RSpec.describe PlayersService do

  describe '#get_players_for' do
    context 'returns lists of players with goals and points:' do
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

      def create_game(pl1, pl2, pl3, pl4, g1, g2, p1, p2, s = :finished)
        game = FactoryGirl.create(:game, status: s)
        FactoryGirl.create(:team, game: game, players: [players[pl1], players[pl2]], goals: g1, points: p1)
        FactoryGirl.create(:team, game: game, players: [players[pl3], players[pl4]], goals: g2, points: p2)
      end

      it 'example 1' do
        create_game 0,1,2,3, 5,3, +3,-3

        result = PlayersService.get_players_for(group)

        expect(result).to eq([players[0],players[1],players[4],players[2],players[3]])

        expect(result[0].goals).to be 5
        expect(result[0].points).to be 3
        expect(result[0].games_played).to be 1

        expect(result[1].goals).to be 5
        expect(result[1].points).to be 3
        expect(result[1].games_played).to be 1

        expect(result[2].goals).to be 0
        expect(result[2].points).to be 0
        expect(result[2].games_played).to be 0

        expect(result[3].goals).to be 3
        expect(result[3].points).to be -3
        expect(result[3].games_played).to be 1

        expect(result[4].goals).to be 3
        expect(result[4].points).to be -3
        expect(result[4].games_played).to be 1
      end

      it 'example 2' do
        create_game 0,1,2,3, 5,3, +3,-3
        create_game 1,2,3,0, 5,7, -3,+3

        result = PlayersService.get_players_for(group)

        expect(result).to eq([players[0],players[1],players[3],players[4],players[2]])

        expect(result[0].goals).to be 12
        expect(result[0].points).to be 6
        expect(result[0].games_played).to be 2

        expect(result[1].goals).to be 10
        expect(result[1].points).to be 0
        expect(result[1].games_played).to be 2

        expect(result[2].goals).to be 10
        expect(result[2].points).to be 0
        expect(result[2].games_played).to be 2

        expect(result[3].goals).to be 0
        expect(result[3].points).to be 0
        expect(result[3].games_played).to be 0

        expect(result[4].goals).to be 8
        expect(result[4].points).to be -6
        expect(result[4].games_played).to be 2
      end

    end
  end

end
