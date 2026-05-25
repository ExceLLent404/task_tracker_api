FactoryBot.define do
  factory :task_template do
    title { Faker::Lorem.sentence(word_count: 3) }
    description { Faker::Lorem.paragraph }
    schedule_type { "once" }
    schedule_options { {} }
    start_date { Faker::Date.forward(days: 30) }
    active { true }

    trait :daily do
      schedule_type { "daily" }
      schedule_options { { "every_n_days" => 1 } }
    end

    trait :monthly do
      schedule_type { "monthly_specific_date" }
      schedule_options { { "day_of_month" => 15 } }
    end

    trait :specific_dates do
      schedule_type { "specific_dates" }
      schedule_options { { "dates" => [ Date.current.to_s, Date.tomorrow.to_s ] } }
    end

    trait :odd_even do
      schedule_type { "odd_even_days" }
      schedule_options { { "type" => "odd" } }
    end
  end
end
