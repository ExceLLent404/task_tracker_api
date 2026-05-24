FactoryBot.define do
  factory :task_template do
    title { Faker::Lorem.sentence(word_count: 3) }
    description { Faker::Lorem.paragraph }
  end
end
