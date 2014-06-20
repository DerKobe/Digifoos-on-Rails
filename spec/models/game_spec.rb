require 'spec_helper'

RSpec.describe Game, :type => :model do

  it 'expects to have a valid factory' do
    expect(FactoryGirl.build(:game)).to be_valid
  end

  describe 'expects presence of' do
    it 'player1' do
      expect(FactoryGirl.build(:game, player1: nil)).to_not be_valid
    end

    it 'player2' do
      expect(FactoryGirl.build(:game, player2: nil)).to_not be_valid
    end

    it 'player3' do
      expect(FactoryGirl.build(:game, player3: nil)).to_not be_valid
    end

    it 'player4' do
      expect(FactoryGirl.build(:game, player4: nil)).to_not be_valid
    end

    it 'session' do
      expect(FactoryGirl.build(:game, session: nil)).to_not be_valid
    end
  end

end