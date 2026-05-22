FactoryBot.define do
  factory :task do
    title { Faker::Lorem.sentence(word_count: 3) }
    description { Faker::Lorem.paragraph }
    scheduled_date { Faker::Date.forward(days: 30) }
    status { :scheduled }
  end
end
