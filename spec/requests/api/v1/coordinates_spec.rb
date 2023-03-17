require 'swagger_helper'

RSpec.describe 'api/v1/coordinates', type: :request do

  path '/api/v1/accommodations/{accommodation_id}/coordinates' do
    # You'll want to customize the parameter types...
    parameter name: 'accommodation_id', in: :path, type: :string, description: 'accommodation_id'

    post('create coordinate') do
      tags 'Coordinate'
      consumes 'application/json'
      parameter name: :coordinate,
                in: :body,
                required: true,
                schema: {
                  type: :object,
                  properties: {
                    latitude: { type: :string, format: :decimal },
                    longitude: { type: :string, format: :decimal }
                  },
                  required: [ :latitude, :longitude ]
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

  path '/api/v1/accommodations/{accommodation_id}/coordinates/{id}' do
    # You'll want to customize the parameter types...
    parameter name: 'accommodation_id', in: :path, type: :string, description: 'accommodation_id'
    parameter name: 'id', in: :path, type: :string, description: 'id'

    get('show coordinate') do
      tags 'Coordinate'
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

    patch('update coordinate') do
      tags 'Coordinate'
      consumes 'application/json'
      parameter name: :coordinate,
                in: :body,
                required: false,
                schema: {
                  type: :object,
                  properties: {
                    latitude: { type: :string, format: :decimal },
                    longitude: { type: :string, format: :decimal }
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

    put('update coordinate') do
      tags 'Coordinate'
      consumes 'application/json'
      parameter name: :coordinate,
                in: :body,
                required: false,
                schema: {
                  type: :object,
                  properties: {
                    latitude: { type: :string, format: :decimal },
                    longitude: { type: :string, format: :decimal }
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

    delete('delete coordinate') do
      tags 'Coordinate'
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
