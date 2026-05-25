class SetTaskTemplateStartDate < ActiveRecord::Migration[8.1]
  def up
    execute <<-SQL
      UPDATE task_templates
      SET start_date = task_instances.scheduled_date
      FROM task_instances
      WHERE task_instances.task_template_id = task_templates.id
    SQL
  end

  def down
  end
end
