# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :game do
    association :player1, factory: :player
    association :player2, factory: :player
    association :player3, factory: :player
    association :player4, factory: :player
    association :session, factory: :session
  end
end
