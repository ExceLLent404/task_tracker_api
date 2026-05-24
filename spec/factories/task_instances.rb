FactoryBot.define do
  factory :task_instance do
    task_template
    scheduled_date { Faker::Date.forward(days: 30) }
    status { :scheduled }
  end
end
