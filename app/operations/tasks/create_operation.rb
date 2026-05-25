module Tasks
  class CreateOperation < BaseOperation
    def call(
      title:,
      description: nil,
      scheduled_date:,
      status: "scheduled",
      schedule_type: "once",
      schedule_options: {},
      active: :true,
      tag_ids: []
    )
      date = Date.iso8601(scheduled_date)

      template = TaskTemplate.new(
        title: title,
        description: description,
        schedule_type: schedule_type,
        schedule_options: schedule_options,
        start_date: date,
        active: true,
        tag_ids: tag_ids
      )

      instance = TaskInstance.new(
        task_template: template,
        scheduled_date: date,
        status: status
      )

      ActiveRecord::Base.transaction do
        template.save!
        instance.save! if template.once? || status != "scheduled"
      end

      Task.from_instance(instance)
    rescue Date::Error
      raise UserInputError, "Invalid date format"
    end
  end
end
