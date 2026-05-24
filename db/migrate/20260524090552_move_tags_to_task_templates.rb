class MoveTagsToTaskTemplates < ActiveRecord::Migration[8.1]
  def up
    remove_foreign_key :task_tags, :tasks
    rename_table :task_tags, :task_template_tags
    rename_column :task_template_tags, :task_id, :task_template_id
    add_foreign_key :task_template_tags, :task_templates

    execute <<-SQL
      UPDATE task_template_tags
      SET task_template_id = (
        SELECT tt.id
        FROM task_templates tt
        WHERE tt.old_task_id = task_template_tags.task_template_id
      )
    SQL

    remove_column :task_templates, :old_task_id
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
