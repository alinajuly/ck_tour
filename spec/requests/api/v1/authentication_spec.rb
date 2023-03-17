require 'swagger_helper'

RSpec.describe 'api/v1/authentication', type: :request do
  path '/api/v1/auth/login' do
    post('authentication user') do
      tags 'Authentication'
      description 'authentication user'
      consumes 'application/json'
      parameter name: :user,
                in: :body,
                required: true,
                schema: {
                  type: :object,
                  properties: {
                    email: { type: :string },
                    password: { type: :string }
                  },
                  required: [ :email, :password ]
                }
      
      response(201, 'successful') do
        it 'should returns status response' do
          expect(response.status).to eq(201)
        end

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
