module Tasks
  class UpdateOperation < BaseOperation
    def call(instance:, **attrs)
      template = instance.task_template

      ActiveRecord::Base.transaction do
        template_attrs =
        attrs.slice(:title, :description, :schedule_type, :schedule_options, :start_date, :active, :tag_ids)
        template.update!(template_attrs) if template_attrs.any?

        instance_attrs = attrs.slice(:status, :scheduled_date)
        if instance_attrs.any?
          instance.save! unless instance.persisted?
          instance.update!(instance_attrs)
        end
      end

      Task.from_instance(instance)
    end
  end
end
