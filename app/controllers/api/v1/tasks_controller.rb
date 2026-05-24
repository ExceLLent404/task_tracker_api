module Api
  module V1
    class TasksController < ApplicationController
      def index
        instances = TaskInstance.includes(task_template: :tags)
                                .order(created_at: :desc)
        instances = instances.by_status(params[:status])
        instances = instances.by_date_range(
          date_from_params(params[:date_from]),
          date_from_params(params[:date_to])
        )

        tasks = instances.map { |instance| Task.from_instance(instance) }
        render json: TaskBlueprint.render(tasks)
      end

      def show
        instance = TaskInstance.find(params[:id])
        render json: TaskBlueprint.render(Task.from_instance(instance))
      end

      def create
        task = Tasks::CreateOperation.call(**task_params.to_h.symbolize_keys)
        render json: TaskBlueprint.render(task), status: :created
      end

      def update
        task = Tasks::UpdateOperation.call(id: params[:id], **task_params.to_h.symbolize_keys)
        render json: TaskBlueprint.render(task)
      end

      def destroy
        Tasks::DeleteOperation.call(id: params[:id])
        head :no_content
      end

      private

      def task_params
        params.permit(:title, :description, :scheduled_date, :status, tag_ids: [])
      end

      def date_from_params(value)
        return nil if value.blank?

        Date.iso8601(value)
      rescue Date::Error
        nil
      end
    end
  end
end
