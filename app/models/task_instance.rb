class TaskInstance < ApplicationRecord
  belongs_to :task_template

  enum :status, { scheduled: 0, completed: 1 }, validate: true

  validates :scheduled_date, presence: true

  scope :by_status, ->(status) { where(status: status) if status.present? }
  scope :by_date_range, ->(from, to) {
    scope = all
    scope = scope.where(scheduled_date: from..) if from.present?
    scope = scope.where(scheduled_date: ..to) if to.present?
    scope
  }
end
