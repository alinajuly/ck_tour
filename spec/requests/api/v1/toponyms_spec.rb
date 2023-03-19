require 'swagger_helper'

RSpec.describe 'api/v1/toponyms', type: :request do

  path '/api/v1/accommodations/{accommodation_id}/toponyms' do
    # You'll want to customize the parameter types...
    parameter name: 'accommodation_id', in: :path, type: :string, description: 'accommodation_id'

    get('list toponyms') do
      tags 'Toponym'
      produces 'application/json'
      security [ jwt_auth: [] ]

      response(200, 'successful') do
        let(:accommodation_id) { '123' }

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

    post('create toponym') do
      tags 'Toponym'
      consumes 'application/json'
      security [ jwt_auth: [] ]
      parameter name: :coordinate,
                in: :body,
                required: true,
                schema: {
                  type: :object,
                  properties: {
                    locality: { type: :string }
                  },
                  required: [ :locality ]
                }

      response(200, 'successful') do
        let(:accommodation_id) { '123' }

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

  path '/api/v1/accommodations/{accommodation_id}/toponyms/{id}' do
    # You'll want to customize the parameter types...
    parameter name: 'accommodation_id', in: :path, type: :string, description: 'accommodation_id'
    parameter name: 'id', in: :path, type: :string, description: 'id'

    get('show toponym') do
      tags 'Toponym'
      security [ jwt_auth: [] ]
      response(200, 'successful') do
        let(:accommodation_id) { '123' }
        let(:id) { '123' }

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

    put('update toponym') do
      tags 'Toponym'
      consumes 'application/json'
      security [ jwt_auth: [] ]
      parameter name: :coordinate,
                in: :body,
                required: false,
                schema: {
                  type: :object,
                  properties: {
                    locality: { type: :string }
                  }
                }

      response(200, 'successful') do
        let(:accommodation_id) { '123' }
        let(:id) { '123' }

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

    delete('delete toponym') do
      tags 'Toponym'
      security [ jwt_auth: [] ]
      response(200, 'successful') do
        let(:accommodation_id) { '123' }
        let(:id) { '123' }

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
