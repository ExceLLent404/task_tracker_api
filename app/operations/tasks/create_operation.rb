module Tasks
  class CreateOperation < BaseOperation
    def call(title:, scheduled_date:, description: nil, status: "scheduled", tag_ids: [])
      template = TaskTemplate.new(
        title: title,
        description: description,
        tag_ids: tag_ids
      )

      ActiveRecord::Base.transaction do
        template.save!

        @instance = template.task_instances.create!(
          scheduled_date: scheduled_date,
          status: status
        )
      end

      Task.from_instance(@instance)
    end
  end
end
