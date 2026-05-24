class Tag < ApplicationRecord
  has_many :task_template_tags, dependent: :destroy
  has_many :task_templates, through: :task_template_tags

  validates :name, presence: true, uniqueness: true
  validates :system, inclusion: { in: [ true, false ] }
end
