require 'rails_helper'
require 'swagger_helper'

RSpec.describe 'api/v1/admins', type: :request do
  path '/api/v1/admins/create_admin' do
    post('create admin') do
      tags 'Admin'
      description 'Creates a new admin'
      consumes 'application/json'
      security [ jwt_auth: [] ]
      parameter name: :user,
                in: :body,
                required: true,
                schema: {
                  type: :object,
                  properties: {
                    name: { type: :string },
                    email: { type: :string },
                    password: { type: :string }
                  },
                  required: [ :name, :email, :password ]
                }

      response(201, 'successful created') do
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

      response(401, 'unauthorized') do
        it 'should returns status response' do
          expect(response.status).to eq(401)
        end
      end

      response(404, 'not found') do
        it 'should returns status response' do
          expect(response.status).to eq(404)
        end
      end

      response(422, 'invalid request') do
        it 'should returns status response' do
          expect(response.status).to eq(422)
        end
      end
    end
  end
end
