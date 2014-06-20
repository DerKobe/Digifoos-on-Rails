# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :session do
    sequence(:name) { |n| "Session #{n}" }
    association :user, factory: :user
  end
end
