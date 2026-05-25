class TaskBlueprint < Blueprinter::Base
  identifier :id

  fields :title, :description, :scheduled_date, :status,
         :schedule_type, :schedule_options, :start_date, :active

  field :created_at do |task|
    task.created_at.iso8601
  end

  field :updated_at do |task|
    task.updated_at.iso8601
  end

  association :tags, blueprint: TagBlueprint, view: :index

  view :index do
    excludes :description, :schedule_type, :schedule_options, :start_date, :active, :created_at, :updated_at
  end
end
