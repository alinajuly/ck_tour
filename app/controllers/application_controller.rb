class ApplicationController < ActionController::API
  include JsonWebToken

  before_action :authenticate_request

  private

  def authenticate_request
    header = request.headers['Authorization']
    if header.present?
      token = header.split(' ').last
      decoded = jwt_decode(token)
      @current_user = User.find(decoded[:user_id])
    else
      render json: { error: 'Authorization header missing' }, status: :unauthorized
    end
  end
end


# def authenticate_request
#   header = request.headers['Authorization']
#   if header.present?
#     header = header.split(' ').last if header
#     decoded = jwt_decode(header)
#     @current_user = User.find(decoded[:user_id])

#     # Add JWT token to request headers
#     request.headers['Authorization'] = "Bearer #{header}"
#   else
#       render json: { error: 'Authorization header missing' }, status: :unauthorized
#   end
# end
