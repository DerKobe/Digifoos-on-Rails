require 'spec_helper'

RSpec.describe Team, :type => :model do
  describe 'expects to have a valid factories' do
    it 'for team' do
      expect(FactoryGirl.build(:team)).to be_valid
    end

    it 'for team with one player' do
      expect(FactoryGirl.create(:team_with_one_player)).to be_valid
    end

    it 'for team with two players' do
      expect(FactoryGirl.create(:team_with_two_players)).to be_valid
    end
  end

  describe 'validations' do
    context 'regarding uniqueness of players' do
      it 'allows team with no players' do
        team = FactoryGirl.build :team
        expect(team).to be_valid
      end

      it 'allows team with one player' do
        team = FactoryGirl.build :team_with_one_player
        expect(team).to be_valid
      end

      it 'allows team with two players' do
        team = FactoryGirl.build :team_with_two_players
        expect(team).to be_valid
      end

      it 'allows two teams of same game with different players each (1/4)' do
        team1 = FactoryGirl.build :team_with_one_player
        team2 = FactoryGirl.build :team_with_one_player, game: team1.game
        expect(team1).to be_valid
        expect(team2).to be_valid
      end

      it 'allows two teams of same game with different players each (2/4)' do
        team1 = FactoryGirl.build :team_with_two_players
        team2 = FactoryGirl.build :team_with_one_player, game: team1.game
        expect(team1).to be_valid
        expect(team2).to be_valid
      end

      it 'allows two teams of same game with different players each (3/4)' do
        team1 = FactoryGirl.build :team_with_two_players
        team2 = FactoryGirl.build :team_with_two_players, game: team1.game
        expect(team1).to be_valid
        expect(team2).to be_valid
      end
    end

  end
end
