require 'rails_helper'
require 'swagger_helper'

RSpec.describe 'api/v1/coordinates', type: :request do

  path '/api/v1/{parentable_type}/{parentable_id}/coordinates' do
    # You'll want to customize the parameter types...
    parameter name: 'parentable_type', in: :path, type: :string, description: 'f.e. attractions, accommodations'
    parameter name: 'parentable_id', in: :path, type: :string, description: 'f.e. attractions_id, accommodations_id'

    post('create coordinate') do
      tags 'Coordinate'
      consumes 'application/json'
      security [ jwt_auth: [] ]
      parameter name: :coordinate,
                in: :body,
                required: true,
                schema: {
                  type: :object,
                  properties: {
                    latitude: { type: :string, format: :decimal },
                    longitude: { type: :string, format: :decimal }
                  },
                  required: %i[latitude longitude]
                }

      response(201, 'successful created') do
        it 'should returns status response' do
          expect(response.status).to eq(201)
        end
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

      response(200, 'successful') do
        it 'should returns status response' do
          expect(response.status).to eq(200)
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

    put('update coordinate') do
      tags 'Coordinate'
      consumes 'application/json'
      security [ jwt_auth: [] ]
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

    delete('delete coordinate') do
      tags 'Coordinate'
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

      response(200, 'successful') do
        it 'should returns status response' do
          expect(response.status).to eq(200)
        end
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
