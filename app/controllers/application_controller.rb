class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
  rescue_from DomainError, with: :domain_error
  rescue_from UserInputError, with: :user_input_error

  private

  def record_not_found(error)
    render json: { error: "#{error.model} not found" }, status: :not_found
  end

  def record_invalid(error)
    render json: { errors: error.record.errors.full_messages }, status: :unprocessable_content
  end

  def domain_error(error)
    render json: { error: error.message }, status: :unprocessable_content
  end

  def user_input_error(error)
    render json: { error: error.message }, status: :unprocessable_content
  end
end
