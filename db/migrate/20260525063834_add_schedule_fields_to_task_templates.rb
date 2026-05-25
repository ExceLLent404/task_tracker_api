class AddScheduleFieldsToTaskTemplates < ActiveRecord::Migration[8.1]
  def change
    change_table :task_templates do |t|
      t.string :schedule_type, null: false, default: "once"
      t.jsonb :schedule_options, null: false, default: {}
      t.date :start_date, null: false, default: -> { "CURRENT_DATE" }
      t.boolean :active, null: false, default: true
    end
  end
end
