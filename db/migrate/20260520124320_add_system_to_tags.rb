class AddSystemToTags < ActiveRecord::Migration[8.1]
  def change
    add_column :tags, :system, :boolean, null: false, default: false
  end
end
