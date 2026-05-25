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
  attribute :schedule_type, :string
  attribute :schedule_options, default: -> { {} }
  attribute :start_date, :date
  attribute :active, :boolean, default: true
  attribute :created_at, :datetime
  attribute :updated_at, :datetime
  attribute :tags, default: -> { [] }

  def id
    "#{template_id}_#{scheduled_date}"
  end

  def self.from_instance(instance)
    from_template_and_date(instance.task_template, instance.scheduled_date, instance)
  end

  def self.from_template_and_date(template, date, instance = nil)
    new(
      template_id: template.id,
      instance_id: instance&.id,
      title: template.title,
      description: template.description,
      scheduled_date: date,
      status: instance&.status || "scheduled",
      schedule_type: template.schedule_type,
      schedule_options: template.schedule_options,
      start_date: template.start_date,
      active: template.active,
      created_at: instance&.created_at || template.created_at,
      updated_at: instance&.updated_at || template.updated_at,
      tags: template.tags
    )
  end
end
