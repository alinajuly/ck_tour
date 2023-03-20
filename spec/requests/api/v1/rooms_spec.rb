require 'swagger_helper'

RSpec.describe 'api/v1/rooms', type: :request do

  path '/api/v1/accommodations/{accommodation_id}/rooms' do
    # You'll want to customize the parameter types...
    parameter name: 'accommodation_id', in: :path, type: :string, description: 'accommodation_id'
    get('list rooms') do
      tags 'Room'
      consumes 'application/json'
      parameter name: :room,
                in: :body,
                required: true,
                schema: {
                  type: :object,
                  properties: {
                    check_in: { type: :string },
                    check_out: { type: :string },
                    number_of_peoples: { type: :string },
                  },
                  required: false
                }

      response(200, 'successful') do
        let(:accommodation_id) { '1' }

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

    post('create room') do
      tags 'Room'
      consumes 'application/json'
      security [ jwt_auth: [] ]
      parameter name: :room,
                in: :body,
                required: true,
                schema: {
                  type: :object,
                  properties: {
                    name: { type: :string },
                    places: { type: :integer },
                    quantity: { type: :integer },
                    description: { type: :string },
                    bed: { type: :string },
                    price_per_night: { type: :integer }
                  },
                  required: [ :name, :places, :bed, :description, :quantity, :price_per_night ]
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

  path '/api/v1/accommodations/{accommodation_id}/rooms/{id}' do
    # You'll want to customize the parameter types...
    parameter name: 'accommodation_id', in: :path, type: :string, description: 'accommodation_id'
    parameter name: 'room_id', in: :path, type: :string, description: 'room_id'

    get('show room') do
      tags 'Room'

      response(200, 'successful') do
        let(:accommodation_id) { '123' }
        let(:room_id) { '123' }

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

    put('update room') do
      tags 'Room'
      consumes 'application/json'
      security [ jwt_auth: [] ]
      parameter name: :room,
              in: :body,
              schema: {
                type: :object,
                properties: {
                  name: { type: :string },
                  places: { type: :integer },
                  quantity: { type: :integer },
                  description: { type: :string },
                  bed: { type: :string },
                  price_per_night: { type: :integer }
                },
                required: false
              }

      response(200, 'successful') do
        let(:accommodation_id) { '123' }
        let(:room_id) { '123' }

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

    delete('delete room') do
      tags 'Room'
      security [ jwt_auth: [] ]
      
      response(200, 'successful') do
        let(:accommodation_id) { '123' }
        let(:room_id) { '123' }

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
