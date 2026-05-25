require "rails_helper"

RSpec.describe ScheduleCalculator do
  describe "once" do
    let(:template) { build(:task_template, :once, start_date: Date.new(2026, 6, 15)) }

    it "returns start_date when in range" do
      dates = described_class.new(template).dates(from: Date.new(2026, 6, 1), to: Date.new(2026, 6, 30))
      expect(dates).to eq([ Date.new(2026, 6, 15) ])
    end

    it "returns empty when outside range" do
      dates = described_class.new(template).dates(from: Date.new(2026, 7, 1), to: Date.new(2026, 7, 31))
      expect(dates).to eq([])
    end
  end

  describe "daily" do
    let(:template) { build(:task_template, :daily, start_date: Date.new(2026, 6, 1)) }

    it "returns every day from start_date" do
      dates = described_class.new(template).dates(from: Date.new(2026, 6, 1), to: Date.new(2026, 6, 5))
      expect(dates).to eq([
        Date.new(2026, 6, 1),
        Date.new(2026, 6, 2),
        Date.new(2026, 6, 3),
        Date.new(2026, 6, 4),
        Date.new(2026, 6, 5)
      ])
    end

    it "returns every 2nd day" do
      template.schedule_options = { "every_n_days" => 2 }
      dates = described_class.new(template).dates(from: Date.new(2026, 6, 1), to: Date.new(2026, 6, 10))
      expect(dates).to eq([
        Date.new(2026, 6, 1),
        Date.new(2026, 6, 3),
        Date.new(2026, 6, 5),
        Date.new(2026, 6, 7),
        Date.new(2026, 6, 9)
      ])
    end
  end

  describe "monthly_specific_date" do
    let(:template) { build(:task_template, :monthly, start_date: Date.new(2026, 1, 15)) }

    it "returns 15th of each month" do
      dates = described_class.new(template).dates(from: Date.new(2026, 1, 1), to: Date.new(2026, 3, 31))
      expect(dates).to eq([
        Date.new(2026, 1, 15),
        Date.new(2026, 2, 15),
        Date.new(2026, 3, 15)
      ])
    end

    it "uses last day for months with fewer days" do
      template.schedule_options = { "day_of_month" => 31 }
      dates = described_class.new(template).dates(from: Date.new(2026, 1, 1), to: Date.new(2026, 4, 30))
      expect(dates).to eq([
        Date.new(2026, 1, 31),
        Date.new(2026, 2, 28),
        Date.new(2026, 3, 31),
        Date.new(2026, 4, 30)
      ])
    end
  end

  describe "specific_dates" do
    let(:template) do
      build(:task_template, :specific_dates, schedule_options: { "dates" => [ Date.new(2026, 6, 1).to_s ] }, start_date: Date.new(2026, 6, 1))
    end

    it "returns only specified dates within range" do
      dates = described_class.new(template).dates(from: Date.new(2026, 6, 1), to: Date.new(2026, 6, 10))
      expect(dates.size).to eq(1)
    end
  end

  describe "odd_even_days" do
    let(:template) { build(:task_template, :odd_even, start_date: Date.new(2026, 6, 1)) }

    it "returns only odd days" do
      dates = described_class.new(template).dates(from: Date.new(2026, 6, 1), to: Date.new(2026, 6, 5))
      expect(dates).to eq([
        Date.new(2026, 6, 1),
        Date.new(2026, 6, 3),
        Date.new(2026, 6, 5)
      ])
    end
  end
end
