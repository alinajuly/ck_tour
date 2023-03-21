class ApplicationController < ActionController::API
  include JsonWebToken
  include Pundit::Authorization

  before_action :authenticate_request

  private

  def authenticate_request
    header = request.headers['Authorization']
    if header.present?
      token = header.split(' ').last
      decoded = jwt_decode(token)
      @current_user = User.find(decoded[:user_id])
    else
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end

  def user_not_authorized
    render json: { error: 'You are not authorized to perform this action.' }, status: :unauthorized
  end
end
