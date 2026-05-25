module TaskInstances
  class FindByCompositeId
    def self.call(composite_id)
      template_id, scheduled_date = composite_id.split("_", 2)
      scheduled_date = Date.iso8601(scheduled_date)

      instance = TaskInstance.find_by(
        task_template_id: template_id,
        scheduled_date: scheduled_date
      )

      return instance if instance

      template = TaskTemplate.find(template_id)
      dates = ScheduleCalculator.new(template).dates(from: scheduled_date, to: scheduled_date)

      raise ActiveRecord::RecordNotFound unless dates.include?(scheduled_date)

      TaskInstance.new(
        task_template: template,
        scheduled_date: scheduled_date,
        status: "scheduled"
      )
    rescue Date::Error
      raise ActiveRecord::RecordNotFound
    end
  end
end
