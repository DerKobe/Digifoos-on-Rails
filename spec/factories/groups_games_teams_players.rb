# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  # --------------------------------------- Groups --------------------------------------
  factory :group do
    user
    sequence(:name) { |n| "Group #{n}" }
  end

  # --------------------------------------- Games ---------------------------------------
  factory :game do
    group

    factory :game_with_one_team do
      after(:create) { |g| factory :team, game: g }
    end

    factory :game_with_teams_and_one_player_each do
      after(:create) do |g|
        g.teams << create(:team_with_one_player, game: g)
        g.teams << create(:team_with_one_player, game: g)
      end
    end

    factory :game_with_teams_and_two_players_each do
      after(:create) do |g|
        g.teams << create(:team_with_two_players, game: g)
        g.teams << create(:team_with_two_players, game: g)
      end
    end
  end

  # --------------------------------------- Teams ---------------------------------------
  factory :team do
    game

    factory :team_with_one_player do
      after(:create) { |t| create :player, teams: [t], group: t.game.group }
    end

    factory :team_with_two_players do
      after(:create) do |t|
        create :player, teams: [t], group: t.game.group
        create :player, teams: [t], group: t.game.group
      end
    end
  end

  # --------------------------------------- Players -------------------------------------
  factory :player do
    group
    sequence(:name) { |n| "Player #{n}" }
  end
end
