FactoryGirl.define do
  factory :user do
    nickname "hoge"
    email { Faker::Internet.email }
    password { Faker::Number.number(8) }
  end
end