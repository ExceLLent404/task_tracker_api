class Task
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::Serialization

  attribute :template_id, :integer
  attribute :instance_id, :integer
  attribute :title, :string
  attribute :description, :string
  attribute :scheduled_date, :date
  attribute :status, :string
  attribute :created_at, :datetime
  attribute :updated_at, :datetime
  attribute :tags, default: -> { [] }

  def id
    "#{template_id}_#{scheduled_date}"
  end

  def self.from_instance(instance)
    template = instance.task_template

    new(
      template_id: template.id,
      instance_id: instance.id,
      title: template.title,
      description: template.description,
      scheduled_date: instance.scheduled_date,
      status: instance.status,
      created_at: instance.created_at,
      updated_at: instance.updated_at,
      tags: template.tags
    )
  end
end
