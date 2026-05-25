module Api
  module V1
    class TasksController < ApplicationController
      before_action :set_instance, only: [ :show, :update, :destroy ]

      def index
        tasks = Tasks::ListQuery.call(
          date_from: params[:date_from],
          date_to: params[:date_to],
          status: params[:status]
        )
        render json: TaskBlueprint.render(tasks, view: :index)
      end

      def show
        render json: TaskBlueprint.render(Task.from_instance(@instance))
      end

      def create
        task = Tasks::CreateOperation.call(**task_params.to_h.symbolize_keys)
        render json: TaskBlueprint.render(task), status: :created
      end

      def update
        task = Tasks::UpdateOperation.call(instance: @instance, **task_params.to_h.symbolize_keys)
        render json: TaskBlueprint.render(task)
      end

      def destroy
        Tasks::DeleteOperation.call(instance: @instance)
        head :no_content
      end

      private

      def set_instance
        @instance = TaskInstances::FindByCompositeId.call(params[:id])
      end

      def task_params
        params.permit(
          :title, :description, :scheduled_date, :status,
          :schedule_type, :active, schedule_options: {},
          tag_ids: []
        )
      end
    end
  end
end
