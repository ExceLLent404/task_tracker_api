require "swagger_helper"

RSpec.describe "Tags API", type: :request do
  path "/api/v1/tags" do
    get "List tags" do
      tags "Tags"
      produces "application/json"

      response "200", "successful response" do
        schema type: :array,
               items: {
                 type: :object,
                 properties: {
                   id: { type: :integer },
                   name: { type: :string }
                 },
                 required: %w[id name]
               }

        before { create_pair(:tag) }

        run_test! do |response|
          body = JSON.parse(response.body)
          expect(body.size).to eql(2)
        end
      end
    end

    post "Create tag" do
      tags "Tags"
      consumes "application/json"
      produces "application/json"

      parameter name: :tag, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string }
        },
        required: %w[name]
      }

      response "201", "tag created" do
        let(:tag) { { name: "New Tag" } }

        run_test! do |response|
          body = JSON.parse(response.body)
          expect(body["name"]).to eql(tag[:name])
        end
      end

      response "422", "validation error" do
        let(:tag) { { name: "" } }

        run_test! do |response|
          body = JSON.parse(response.body)
          expect(body["errors"]).to be_present
        end
      end
    end
  end

  path "/api/v1/tags/{id}" do
    parameter name: :id, in: :path, type: :integer

    get "Get tag by ID" do
      tags "Tags"
      produces "application/json"

      response "200", "tag found" do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 name: { type: :string },
                 created_at: { type: :string, format: "date-time" },
                 updated_at: { type: :string, format: "date-time" }
               },
               required: %w[id name created_at updated_at]

        let(:id) { create(:tag).id }

        run_test!
      end

      response "404", "tag not found" do
        let(:id) { -1 }

        run_test!
      end
    end

    patch "Update tag" do
      tags "Tags"
      consumes "application/json"
      produces "application/json"

      parameter name: :tag, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string }
        }
      }

      response "200", "tag updated" do
        let(:id) { create(:tag).id }
        let(:tag) { { name: "Updated tag" } }

        run_test! do |response|
          body = JSON.parse(response.body)
          expect(body["name"]).to eql(tag[:name])
        end
      end

      response "404", "tag not found" do
        let(:id) { -1 }
        let(:tag) { { name: "Updated tag" } }

        run_test!
      end

      response "422", "validation error" do
        let(:id) { create(:tag).id }
        let(:tag) { { name: "" } }

        run_test! do |response|
          body = JSON.parse(response.body)
          expect(body["errors"]).to be_present
        end
      end
    end

    delete "Delete tag" do
      tags "Tags"

      response "204", "tag deleted" do
        let(:id) { create(:tag).id }

        run_test!
      end

      response "404", "tag not found" do
        let(:id) { -1 }

        run_test!
      end
    end
  end
end
