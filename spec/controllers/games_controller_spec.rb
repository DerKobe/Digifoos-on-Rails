require 'spec_helper'

RSpec.describe GamesController, :type => :controller do

  let(:group)  { FactoryGirl.create :group }

  xit 'creates a game' do
    post :create, id: group.id, action: :games
  end

end
