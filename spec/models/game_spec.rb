require 'spec_helper'

RSpec.describe Game, :type => :model do
  let(:game) { FactoryGirl.build(:game) }

  it 'expects to have a valid factory' do
    expect(game).to be_valid
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