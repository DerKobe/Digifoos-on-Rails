require 'spec_helper'

RSpec.describe Team, :type => :model do
  describe 'expects to have a valid factories' do
    it 'for team' do
      team = FactoryGirl.create(:team)
      expect(team).to be_valid
      expect(team.players.count).to be 0
    end

    it 'for team with one player' do
      team = FactoryGirl.create(:team_with_one_player)
      expect(team).to be_valid
      expect(team.players.count).to be 1
    end

    it 'for team with two players' do
      team = FactoryGirl.create(:team_with_two_players)
      expect(team).to be_valid
      expect(team.players.count).to be 2
    end
  end

  describe 'validates' do
    context 'uniqueness of players:' do
      it 'allows team with no players' do
        team = FactoryGirl.create :team
        expect(team).to be_valid
      end

      it 'allows team with one player' do
        team = FactoryGirl.create :team_with_one_player
        expect(team).to be_valid
      end

      it 'allows team with two different players' do
        team = FactoryGirl.create :team_with_two_players
        expect(team).to be_valid
      end

      it 'denies team with the same player twice' do
        team = FactoryGirl.create :team_with_one_player
        player = team.players.last
        expect { team.players << player }.to raise_exception ActiveRecord::RecordNotUnique
      end
    end

  end
end
