require "swagger_helper"

RSpec.describe "Tasks API", type: :request do
  path "/api/v1/tasks" do
    get "List tasks" do
      tags "Tasks"
      produces "application/json"

      parameter name: :status, in: :query, type: :string, enum: %w[scheduled completed], required: false
      parameter name: :date_from, in: :query, type: :string, format: :date, required: false
      parameter name: :date_to, in: :query, type: :string, format: :date, required: false

      response "200", "successful response" do
        schema type: :array,
               items: {
                 type: :object,
                 properties: {
                   id: { type: :string },
                   title: { type: :string },
                   scheduled_date: { type: :string, format: :date },
                   status: { type: :string, enum: %w[scheduled completed] },
                   tags: {
                     type: :array,
                     items: {
                       type: :object,
                       properties: {
                         id: { type: :integer },
                         name: { type: :string }
                       }
                     }
                   }
                 },
                 required: %w[id title scheduled_date status tags]
               }

        before { create_pair(:task) }

        run_test! do |response|
          body = JSON.parse(response.body)
          expect(body.size).to eql(2)
        end
      end
    end

    post "Create task" do
      tags "Tasks"
      consumes "application/json"
      produces "application/json"

      parameter name: :task, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string },
          description: { type: :string },
          scheduled_date: { type: :string, format: :date },
          status: { type: :string, enum: %w[scheduled completed] },
          tag_ids: {
            type: :array,
            items: { type: :integer }
          }
        },
        required: %w[title scheduled_date]
      }

      response "201", "task created" do
        let(:tag) { create(:tag) }
        let(:task) { attributes_for(:task).merge(tag_ids: [ tag.id ]) }

        run_test! do |response|
          body = JSON.parse(response.body)
          expect(body["title"]).to eql(task[:title])
          expect(body["tags"].size).to eql(1)
          expect(body["tags"].first["id"]).to eql(tag.id)
        end
      end

      response "422", "validation error" do
        let(:task) { attributes_for(:task, title: "") }

        run_test! do |response|
          body = JSON.parse(response.body)
          expect(body["errors"]).to be_present
        end
      end
    end
  end

  path "/api/v1/tasks/{id}" do
    parameter name: :id, in: :path, type: :string

    get "Get task by ID" do
      tags "Tasks"
      produces "application/json"

      response "200", "task found" do
        schema type: :object,
               properties: {
                 id: { type: :string },
                 title: { type: :string },
                 description: { type: :string, nullable: true },
                 scheduled_date: { type: :string, format: :date },
                 status: { type: :string, enum: %w[scheduled completed] },
                 created_at: { type: :string, format: "date-time" },
                 updated_at: { type: :string, format: "date-time" },
                 tags: {
                   type: :array,
                   items: {
                     type: :object,
                     properties: {
                       id: { type: :integer },
                       name: { type: :string }
                     }
                   }
                 }
               },
               required: %w[id title description scheduled_date status created_at updated_at tags]

        let(:id) { create(:task).id }

        run_test!
      end

      response "404", "task not found" do
        let(:id) { "-1_2000-01-01" }

        run_test!
      end
    end

    patch "Update task" do
      tags "Tasks"
      consumes "application/json"
      produces "application/json"

      parameter name: :task, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string },
          description: { type: :string },
          scheduled_date: { type: :string, format: :date },
          status: { type: :string, enum: %w[scheduled completed] },
          tag_ids: {
            type: :array,
            items: { type: :integer }
          }
        }
      }

      response "200", "task updated" do
        let(:id) { create(:task).id }
        let(:tag) { create(:tag) }
        let(:task) { { title: "Updated task", tag_ids: [ tag.id ] } }

        run_test! do |response|
          body = JSON.parse(response.body)
          expect(body["title"]).to eql(task[:title])
          expect(body["tags"].size).to eql(1)
          expect(body["tags"].first["id"]).to eql(tag.id)
        end
      end

      response "404", "task not found" do
        let(:id) { "-1_2000-01-01" }
        let(:task) { { title: "Updated task" } }

        run_test!
      end

      response "422", "validation error" do
        let(:id) { create(:task).id }
        let(:task) { { title: "" } }

        run_test! do |response|
          body = JSON.parse(response.body)
          expect(body["errors"]).to be_present
        end
      end
    end

    delete "Delete task" do
      tags "Tasks"

      response "204", "task deleted" do
        let(:id) { create(:task).id }

        run_test!
      end

      response "404", "task not found" do
        let(:id) { "-1_2000-01-01" }

        run_test!
      end
    end
  end
end
