class CreateTaskInstances < ActiveRecord::Migration[8.1]
  def change
    create_table :task_instances do |t|
      t.references :task_template, null: false, foreign_key: true
      t.date :scheduled_date, null: false
      t.integer :status, null: false, default: 0

      t.timestamps
    end

    add_index :task_instances, [ :task_template_id, :scheduled_date ], unique: true
    add_index :task_instances, :scheduled_date
  end
end
