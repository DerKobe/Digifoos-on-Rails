require 'spec_helper'

RSpec.describe Game, :type => :model do
  let(:game) { FactoryGirl.build(:game) }
  let(:game_with_teams_and_one_player_each) { FactoryGirl.create(:game_with_teams_and_one_player_each) }
  let(:game_with_teams_and_two_players_each) { FactoryGirl.create(:game_with_teams_and_two_players_each) }

  describe 'expects to have a valid factories' do
    it 'for game' do
      expect(game).to be_valid
    end

    it 'for game with teams and one player each' do
      expect(game_with_teams_and_one_player_each).to be_valid
    end

    it 'game with teams and two players each' do
      expect(game_with_teams_and_two_players_each).to be_valid
    end
  end

  it 'has three possible statuses' do
    expect(Game.statuses).to eq({ 'created' => 0, 'running' => 1, 'finished' => 2 })
  end

  describe 'validations:' do
    it 'presence of group' do
      game.group = nil
      expect(game).to_not be_valid
    end

    it 'presence of status' do
      game.status = nil
      expect(game).to_not be_valid
    end

    it 'the same player can not play in both teams' do
      player = game_with_teams_and_one_player_each.teams.last.players.last
      game_with_teams_and_one_player_each.teams.first.players << player
      expect(game_with_teams_and_one_player_each).to_not be_valid
    end

    context 'there can be only one open game per group:' do
      it 'example 1' do
        FactoryGirl.create :game, status: :created, group: game.group
        expect{game.created!}.to raise_exception ActiveRecord::RecordInvalid
      end

      it 'example 2' do
        FactoryGirl.create :game, status: :running, group: game.group
        expect{game.created!}.to raise_exception ActiveRecord::RecordInvalid
      end

      it 'example 3' do
        FactoryGirl.create :game, status: :created, group: game.group
        expect{game.running!}.to raise_exception ActiveRecord::RecordInvalid
      end

      it 'example 4' do
        FactoryGirl.create :game, status: :running, group: game.group
        expect{game.running!}.to raise_exception ActiveRecord::RecordInvalid
      end

      it 'example 5' do
        FactoryGirl.create :game, status: :finished, group: game.group
        game.running!
        expect(game).to be_valid
      end

      it 'example 5' do
        FactoryGirl.create :game, status: :finished, group: game.group
        game.created!
        expect(game).to be_valid
      end
    end
  end

end