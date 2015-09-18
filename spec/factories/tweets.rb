FactoryGirl.define do
  factory :tweet do
    association :user
    text { Faker::Lorem.word }
    image { Faker::Internet.url }
  end
end