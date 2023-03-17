# class JWTMiddleware
#   def initialize(app)
#     @app = app
#   end

#   def call(env)
#     token = env['HTTP_AUTHORIZATION'].to_s.split(' ').last
#     if token.present?
#       env['HTTP_AUTHORIZATION'] = "Bearer #{token}"
#     end
#     @app.call(env)
#   end
# end
