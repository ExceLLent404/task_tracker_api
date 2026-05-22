FactoryBot.define do
  factory :tag do
    name { Faker::Food.unique.fruits }
  end
end
