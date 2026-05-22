class Task < ApplicationRecord
  enum :status, { scheduled: 0, completed: 1 }, validate: true

  validates :title, presence: true
  validates :scheduled_date, presence: true
  validates :status, presence: true
end
