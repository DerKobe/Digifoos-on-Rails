require 'rails_helper'

RSpec.describe GamesController, :type => :controller do

  it 'creates a game' do
    post :create
  end

end
