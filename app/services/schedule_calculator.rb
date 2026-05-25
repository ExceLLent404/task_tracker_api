class ScheduleCalculator
  def initialize(template)
    @template = template
  end

  def dates(from:, to:)
    return [] if from > to

    effective_from = [ @template.start_date, from ].max
    effective_to = to

    return [] if effective_from > effective_to

    case @template.schedule_type
    when "once" then once_dates(effective_from, effective_to)
    when "daily" then daily_dates(effective_from, effective_to)
    when "monthly_specific_date" then monthly_dates(effective_from, effective_to)
    when "specific_dates" then specific_dates(effective_from, effective_to)
    when "odd_even_days" then odd_even_dates(effective_from, effective_to)
    else []
    end
  end

  private

  def once_dates(from, to)
    @template.start_date.between?(from, to) ? [ @template.start_date ] : []
  end

  def daily_dates(from, to)
    n = @template.schedule_options["every_n_days"] || 1
    result = []
    current = from
    while current <= to
      result << current
      current += n.days
    end
    result
  end

  def monthly_dates(from, to)
    day = @template.schedule_options["day_of_month"]
    result = []
    current = from.beginning_of_month
    while current <= to
      last_day = current.end_of_month.day
      actual_day = [ day, last_day ].min
      date = current + (actual_day - 1).days
      result << date if date.between?(from, to)
      current += 1.month
    end
    result
  end

  def specific_dates(from, to)
    @template.schedule_options["dates"]
      .map(&:to_date)
      .select { |d| d.between?(from, to) }
  end

  def odd_even_dates(from, to)
    type = @template.schedule_options["type"]
    (from..to).select { |date| type == "odd" ? date.day.odd? : date.day.even? }
  end
end
