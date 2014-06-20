# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :player do
    sequence(:name) { |n| "Player #{n}" }
    association :session, factory: :session
  end
end
