require "rails_helper"

RSpec.describe "Tasks filtering", type: :request do
  let(:start_date) { Date.today }
  let(:end_date) { Date.today + 7.days }
  let!(:scheduled_in_range) { create(:task, status: :scheduled, scheduled_date: Date.today + 1.day) }
  let!(:scheduled_before)  { create(:task, status: :scheduled, scheduled_date: Date.today - 1.day) }
  let!(:scheduled_after)   { create(:task, status: :scheduled, scheduled_date: Date.today + 10.days) }
  let!(:completed_in_range) { create(:task, status: :completed, scheduled_date: Date.today + 3.days) }

  describe "filtering by status" do
    it "returns tasks with specified status" do
      get "/api/v1/tasks", params: { status: "scheduled" }

      body = JSON.parse(response.body)
      ids = body.map { |task| task["id"] }
      expect(ids).to contain_exactly(scheduled_in_range.id, scheduled_before.id, scheduled_after.id)
    end
  end

  describe "filtering by date range" do
    it "returns tasks within date range" do
      get "/api/v1/tasks", params: {
        date_from: start_date.to_s,
        date_to: end_date.to_s
      }

      body = JSON.parse(response.body)
      ids = body.map { |task| task["id"] }
      expect(ids).to contain_exactly(scheduled_in_range.id, completed_in_range.id)
    end
  end

  describe "combined filtering" do
    it "returns tasks with specified status within date range" do
      get "/api/v1/tasks", params: {
        status: "scheduled",
        date_from: start_date.to_s,
        date_to: end_date.to_s
      }

      body = JSON.parse(response.body)
      expect(body.size).to eql(1)
      expect(body.first["id"]).to eql(scheduled_in_range.id)
    end
  end
end
