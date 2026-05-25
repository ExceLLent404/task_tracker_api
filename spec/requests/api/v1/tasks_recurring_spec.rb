require "rails_helper"

RSpec.describe "Recurring tasks", type: :request do
  describe "GET /api/v1/tasks" do
    let!(:daily_template) { create(:task_template, :daily, start_date: Date.today, title: "Daily task") }

    it "returns virtual instances for recurring tasks" do
      get "/api/v1/tasks", params: {
        date_from: Date.today.to_s,
        date_to: (Date.today + 3.days).to_s
      }

      body = JSON.parse(response.body)
      expect(body.size).to eql(4)
    end
  end

  describe "GET /api/v1/tasks/:id for virtual instance" do
    let!(:template) { create(:task_template, :daily, start_date: Date.today) }

    it "returns virtual task when no instance exists" do
      date = Date.today + 2.days
      id = "#{template.id}_#{date}"

      get "/api/v1/tasks/#{id}"

      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body["scheduled_date"]).to eql(date.to_s)
      expect(body["status"]).to eql("scheduled")
      expect(body["schedule_type"]).to eql("daily")
    end
  end

  describe "PATCH /api/v1/tasks/:id for virtual instance" do
    let!(:template) { create(:task_template, :daily, start_date: Date.today) }

    it "creates instance when updating status of virtual task" do
      date = Date.today + 2.days
      id = "#{template.id}_#{date}"

      expect {
        patch "/api/v1/tasks/#{id}", params: { status: "completed" }, as: :json
      }.to change(TaskInstance, :count).by(1)

      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body["status"]).to eql("completed")
    end
  end

  describe "DELETE /api/v1/tasks/:id for virtual instance" do
    let!(:template) { create(:task_template, :daily, start_date: Date.today) }

    it "does nothing for virtual task" do
      date = Date.today + 2.days
      id = "#{template.id}_#{date}"

      expect {
        delete "/api/v1/tasks/#{id}"
      }.not_to change(TaskInstance, :count)

      expect(response).to have_http_status(:no_content)
    end
  end

  describe "PATCH /api/v1/tasks/:id to disable template" do
    let!(:template) { create(:task_template, :daily, start_date: Date.today) }
    let!(:instance) { create(:task_instance, task_template: template, scheduled_date: Date.today) }

    it "deactivates recurring task" do
      id = "#{template.id}_#{instance.scheduled_date}"

      patch "/api/v1/tasks/#{id}", params: { active: false }, as: :json

      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body["active"]).to eql(false)

      get "/api/v1/tasks", params: {
        date_from: Date.today.to_s,
        date_to: (Date.today + 7.days).to_s
      }

      list_body = JSON.parse(response.body)
      expect(list_body).to be_empty
    end
  end
end
