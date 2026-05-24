module Tasks
  class UpdateOperation < BaseOperation
    def call(id:, **attrs)
      instance = TaskInstance.find(id)
      template = instance.task_template

      ActiveRecord::Base.transaction do
        template_attrs = attrs.slice(:title, :description, :tag_ids)
        template.update!(template_attrs) if template_attrs.any?

        instance_attrs = attrs.slice(:status, :scheduled_date)
        instance.update!(instance_attrs) if instance_attrs.any?
      end

      Task.from_instance(instance)
    end
  end
end
