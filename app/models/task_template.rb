class TaskTemplate < ApplicationRecord
  has_many :task_instances, dependent: :destroy
  has_many :task_template_tags, dependent: :destroy
  has_many :tags, through: :task_template_tags

  validates :title, presence: true
end
