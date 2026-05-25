FactoryBot.define do
  factory :task, class: "Task" do
    skip_create

    title { Faker::Lorem.sentence(word_count: 3) }
    description { Faker::Lorem.paragraph }
    scheduled_date { Faker::Date.forward(days: 30) }
    status { :scheduled }
    schedule_type { "once" }
    schedule_options { {} }
    start_date { scheduled_date }
    active { true }

    initialize_with do
      template = create(
        :task_template,
        title: title,
        description: description,
        schedule_type: schedule_type,
        schedule_options: schedule_options,
        start_date: start_date,
        active: active
      )
      instance = create(:task_instance, task_template: template, scheduled_date: scheduled_date, status: status)
      Task.from_instance(instance)
    end
  end
end
