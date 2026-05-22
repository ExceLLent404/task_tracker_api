module Api
  module V1
    class TagsController < ApplicationController
      before_action :set_tag, only: [ :show, :update, :destroy ]

      def index
        tags = Tag.all.order(:name)
        render json: TagBlueprint.render(tags, view: :index)
      end

      def show
        render json: TagBlueprint.render(@tag)
      end

      def create
        tag = Tag.new(tag_params)
        if tag.save
          render json: TagBlueprint.render(tag), status: :created
        else
          render json: { errors: tag.errors.full_messages }, status: :unprocessable_content
        end
      end

      def update
        if @tag.update(tag_params)
          render json: TagBlueprint.render(@tag)
        else
          render json: { errors: @tag.errors.full_messages }, status: :unprocessable_content
        end
      end

      def destroy
        @tag.destroy
        head :no_content
      end

      private

      def set_tag
        @tag = Tag.find(params[:id])
      end

      def tag_params
        params.permit(:name)
      end
    end
  end
end
