require 'rails_helper'
require 'swagger_helper'

RSpec.describe 'api/v1/geolocations', type: :request do

  path '/api/v1/geolocations' do
    get('list geolocations for all') do
      tags 'Map'
      produces 'application/json'

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
  end

  path '/api/v1/{parentable_type}/{parentable_id}/geolocations' do
    parameter name: 'parentable_type', in: :path, type: :string, description: 'f.e. attractions, accommodations'
    parameter name: 'parentable_id', in: :path, type: :string, description: 'f.e. attraction_id, accommodation_id'

    get('list geolocations for all') do
      tags 'Map'
      response(200, 'successful') do
        let(:geolocation_id) { '123' }
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

    post('create geolocation by admin (attraction) or partner (catering/tour)') do
      tags 'Map'
      consumes 'application/json'
      security [ jwt_auth: [] ]
      parameter name: :geolocation,
                in: :body,
                required: true,
                schema: {
                  type: :object,
                  properties: {
                    locality: { type: :string },
                    latitude: { type: :number, format: :float },
                    longitude: { type: :number, format: :float },
                    street: { type: :string },
                    suite: { type: :string },
                    zip_code: { type: :string }
                  },
                  required: %i[locality latitude longitude]
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
  end

  path '/api/v1/{parentable_type}/{parentable_id}/geolocations/{id}' do
    # You'll want to customize the parameter types...
    parameter name: 'parentable_type', in: :path, type: :string, description: 'f.e. attractions, accommodations'
    parameter name: 'parentable_id', in: :path, type: :string, description: 'f.e. attraction_id, accommodation_id'
    parameter name: :id, in: :path, type: :string, description: 'geolocation id'

    get('show geolocation for all') do
      tags 'Map'

      response(200, 'successful') do
        let(:geolocation_id) { '123' }
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

    put('update geolocation by admin or partner') do
      tags 'Map'
      consumes 'application/json'
      security [ jwt_auth: [] ]
      parameter name: :geolocation,
                in: :body,
                required: false,
                schema: {
                  type: :object,
                  properties: {
                    locality: { type: :string },
                    latitude: { type: :number, format: :float },
                    longitude: { type: :number, format: :float },
                    street: { type: :string },
                    suite: { type: :string },
                    zip_code: { type: :string }
                  }
                }

      response(200, 'successful') do
        let(:geolocation_id) { '123' }
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

    delete('delete geolocation by admin or partner') do
      tags 'Map'
      security [ jwt_auth: [] ]

      response(200, 'successful') do
        let(:geolocation_id) { '123' }
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

  path '/api/v1/tours/{tour_id}/places/{place_id}/geolocations' do
    parameter name: 'tour_id', in: :path, type: :string, description: 'tour id'
    parameter name: 'place_id', in: :path, type: :string, description: 'place id'

    post('create geolocation for tour by partner') do
      tags 'Map'
      consumes 'application/json'
      security [ jwt_auth: [] ]
      parameter name: :geolocation,
                in: :body,
                required: true,
                schema: {
                  type: :object,
                  properties: {
                    locality: { type: :string },
                    latitude: { type: :string, format: :decimal },
                    longitude: { type: :string, format: :decimal },
                    street: { type: :string },
                    suite: { type: :string },
                    zip_code: { type: :string }
                  },
                  required: %i[locality latitude longitude]
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
  end

  path '/api/v1/tours/{tour_id}/places/{place_id}/geolocations' do
    parameter name: 'tour_id', in: :path, type: :string, description: 'tour id'
    parameter name: 'place_id', in: :path, type: :string, description: 'place id'
    parameter name: :id, in: :path, type: :string, description: 'geolocation id'

    get('show geolocation for tour for all') do
      tags 'Map'

      response(200, 'successful') do
        let(:geolocation_id) { '123' }
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

    put('update geolocation for tour by partner') do
      tags 'Map'
      consumes 'application/json'
      security [ jwt_auth: [] ]
      parameter name: :geolocation,
                in: :body,
                required: false,
                schema: {
                  type: :object,
                  properties: {
                    locality: { type: :string },
                    latitude: { type: :string, format: :decimal },
                    longitude: { type: :string, format: :decimal },
                    street: { type: :string },
                    suite: { type: :string },
                    zip_code: { type: :string }
                  }
                }

      response(200, 'successful') do
        let(:geolocation_id) { '123' }
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

    delete('delete geolocation for tour by partner') do
      tags 'Map'
      security [ jwt_auth: [] ]

      response(200, 'successful') do
        let(:geolocation_id) { '123' }
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
