class CopyTasksToTemplatesAndInstances < ActiveRecord::Migration[8.1]
  def up
    add_column :task_templates, :old_task_id, :integer

    execute <<-SQL
      INSERT INTO task_templates (title, description, created_at, updated_at, old_task_id)
      SELECT title, description, created_at, updated_at, id
      FROM tasks
    SQL

    execute <<-SQL
      INSERT INTO task_instances (task_template_id, scheduled_date, status, created_at, updated_at)
      SELECT tt.id, t.scheduled_date, t.status, t.created_at, t.updated_at
      FROM task_templates tt
      JOIN tasks t ON t.id = tt.old_task_id
    SQL
  end

  def down
    execute <<-SQL
      INSERT INTO tasks (id, title, description, scheduled_date, status, created_at, updated_at)
      SELECT tt.old_task_id, tt.title, tt.description, ti.scheduled_date, ti.status, tt.created_at, tt.updated_at
      FROM task_templates tt
      JOIN task_instances ti ON ti.task_template_id = tt.id
      WHERE tt.old_task_id IS NOT NULL
    SQL

    remove_column :task_templates, :old_task_id
  end
end
