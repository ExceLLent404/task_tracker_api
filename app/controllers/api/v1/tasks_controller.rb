module Api
  module V1
    class TasksController < ApplicationController
      before_action :set_task, only: [ :show, :update, :destroy ]

      def index
        tasks = Task.all.order(created_at: :desc)
        render json: TaskBlueprint.render(tasks, view: :index)
      end

      def show
        render json: TaskBlueprint.render(@task)
      end

      def create
        task = Task.new(task_params)
        if task.save
          render json: TaskBlueprint.render(task), status: :created
        else
          render json: { errors: task.errors.full_messages }, status: :unprocessable_content
        end
      end

      def update
        if @task.update(task_params)
          render json: TaskBlueprint.render(@task)
        else
          render json: { errors: @task.errors.full_messages }, status: :unprocessable_content
        end
      end

      def destroy
        @task.destroy
        head :no_content
      end

      private

      def set_task
        @task = Task.find(params[:id])
      end

      def task_params
        params.permit(:title, :description, :scheduled_date, :status)
      end
    end
  end
end
