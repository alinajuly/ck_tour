require 'swagger_helper'

RSpec.describe 'api/v1/password', type: :request do

  path '/api/v1/password/forgot' do

    post('forgot password') do
      tags 'Authentication'
      description 'forgot users password'
      consumes 'application/json'
      security [ jwt_auth: [] ]

      parameter name: :user,
                in: :body,
                required: true,
                schema: {
                  type: :object,
                  properties: {
                    email: { type: :string },
                  },
                  required: [ :email ]
                }

      response(200, 'successful') do
        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end
  end

  path '/api/v1/password/reset' do

    post('reset password') do
      tags 'Authentication'
      description 'reset password'
      consumes 'application/json'
      security [ jwt_auth: [] ]
      parameter name: :user,
                in: :body,
                required: false,
                schema: {
                  type: :object,
                  properties: {
                    email: { type: :string },
                    password: { type: :string }
                  }
                }

      response(200, 'successful') do
        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end
  end
end
