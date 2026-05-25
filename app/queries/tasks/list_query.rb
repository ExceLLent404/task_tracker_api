module Tasks
  class ListQuery
    def self.call(date_from:, date_to:, status: nil)
      from = parse_date(date_from) || Date.today
      to = parse_date(date_to) || (Date.today + 7.days)

      templates = TaskTemplate.active.includes(:tags)
      instances = TaskInstance.where(task_template: templates, scheduled_date: from..to)
                              .index_by { |i| [ i.task_template_id, i.scheduled_date ] }

      tasks = []

      templates.each do |template|
        dates = ScheduleCalculator.new(template).dates(from: from, to: to)

        dates.each do |date|
          key = [ template.id, date ]
          instance = instances[key]
          task = Task.from_template_and_date(template, date, instance)
          tasks << task
        end
      end

      tasks = tasks.select { |t| t.status == status } if status.present?
      tasks.sort_by(&:scheduled_date)
    end

    def self.parse_date(value)
      return nil if value.blank?

      Date.iso8601(value)
    rescue Date::Error
      nil
    end
    private_class_method :parse_date
  end
end
