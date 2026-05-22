class TaskBlueprint < Blueprinter::Base
  identifier :id

  fields :title, :description, :scheduled_date, :status

  field :created_at do |task|
    task.created_at.iso8601
  end

  field :updated_at do |task|
    task.updated_at.iso8601
  end

  association :tags, blueprint: TagBlueprint, view: :index

  view :index do
    excludes :description, :created_at, :updated_at
  end
end
