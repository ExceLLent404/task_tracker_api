class CreateTasks < ActiveRecord::Migration[8.1]
  def change
    create_table :tasks do |t|
      t.string :title, null: false
      t.text :description
      t.date :scheduled_date, null: false
      t.integer :status, null: false, default: 0

      t.timestamps
    end

    add_index :tasks, :scheduled_date
  end
end
