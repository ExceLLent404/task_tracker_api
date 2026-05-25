class TaskTemplate < ApplicationRecord
  has_many :task_instances, dependent: :destroy
  has_many :task_template_tags, dependent: :destroy
  has_many :tags, through: :task_template_tags

  enum :schedule_type, {
    once: "once",
    daily: "daily",
    monthly_specific_date: "monthly_specific_date",
    specific_dates: "specific_dates",
    odd_even_days: "odd_even_days"
  }, validate: true

  validates :title, presence: true
  validates :start_date, presence: true

  validate :schedule_options_must_match_type

  scope :active, -> { where(active: true) }

  private

  def schedule_options_must_match_type
    case schedule_type
    when "daily"
      errors.add(:schedule_options, "must contain every_n_days") unless schedule_options["every_n_days"].to_i > 0
    when "monthly_specific_date"
      day = schedule_options["day_of_month"].to_i
      errors.add(:schedule_options, "must contain day_of_month from 1 to 31") unless day.between?(1, 31)
    when "specific_dates"
      unless schedule_options["dates"].is_a?(Array) && schedule_options["dates"].any?
        errors.add(:schedule_options, "must contain dates array")
      end
    when "odd_even_days"
      errors.add(:schedule_options, "must contain type (odd or even)") unless %w[odd even].include?(schedule_options["type"])
    end
  end
end
