FactoryBot.define do
  factory :tag do
    name { Faker::Food.unique.fruits }
    system { false }

    trait :system do
      system { true }
    end
  end
end
