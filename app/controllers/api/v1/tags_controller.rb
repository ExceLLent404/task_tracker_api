module Api
  module V1
    class TagsController < ApplicationController
      def index
        tags = Tag.all.order(:name)
        render json: TagBlueprint.render(tags, view: :index)
      end

      def show
        @tag = Tag.find(params[:id])
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
        tag = Tags::UpdateOperation.call(id: params[:id], data: tag_params)
        render json: TagBlueprint.render(tag)
      end

      def destroy
        Tags::DeleteOperation.call(id: params[:id])
        head :no_content
      end

      private

      def tag_params
        params.permit(:name)
      end
    end
  end
end
