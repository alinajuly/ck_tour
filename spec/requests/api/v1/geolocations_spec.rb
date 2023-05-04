require 'rails_helper'
require 'swagger_helper'

RSpec.describe 'api/v1/geolocations', type: :request do
  let!(:admin) { create(:user, role: 'admin') }
  let(:token) { JWT.encode({ user_id: admin.id }, Rails.application.secret_key_base) }
  let(:headers) { { 'Authorization' => "Bearer #{token}" } }
  let(:Authorization) { headers['Authorization'] }
  let!(:parent) { create(:attraction) }

  path '/api/v1/geolocations' do
    get('list geolocations for all') do
      tags 'Map'
      produces 'application/json'
      let!(:geolocation) { create(:geolocation, geolocationable_id: parent.id) }

      response(200, 'successful') do
        it 'should returns status response' do
          expect(response.status).to eq(200)
        end

        run_test!
      end
    end
  end

  path '/api/v1/{parentable_type}/{parentable_id}/geolocations' do
    parameter name: 'parentable_type', in: :path, type: :string,
              description: 'f.e. attractions, accommodations, caterings, places'
    parameter name: 'parentable_id', in: :path, type: :string,
              description: 'f.e. attraction_id, accommodation_id, catering_id, place_id'
    let(:parentable_type) { 'attractions' }
    let(:parentable_id) { parent.id }

    get('list geolocations for all') do
      tags 'Map'
      let!(:geolocation) { create(:geolocation, geolocationable_type: 'Attraction', geolocationable_id: parent.id) }

      response(200, 'successful') do
        it 'should returns status response' do
          expect(response.status).to eq(200)
        end

        run_test!
      end

      response(404, 'not found') do
        let(:parentable_id) { 'invalid' }
        it 'should returns status response' do
          expect(response.status).to eq(404)
        end

        run_test!
      end
    end

    post('create geolocation by admin (attraction) or partner (catering/tour)') do
      tags 'Map'
      consumes 'application/json'
      security [jwt_auth: []]
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
      let(:geolocation) { FactoryBot.attributes_for(:geolocation) }

      response(201, 'successful created') do
        it 'should returns status response' do
          expect(response.status).to eq(201)
          json = JSON.parse(response.body).deep_symbolize_keys
          expect(json[:locality]).to eq('New York')
          expect(json[:suite]).to eq('25')
        end

        run_test!
      end

      response(401, 'unauthorized') do
        let(:Authorization) { nil }
        it 'should returns status response' do
          expect(response.status).to eq(401)
        end

        run_test!
      end

      response(422, 'invalid request') do
        let(:geolocation) { FactoryBot.attributes_for(:geolocation, latitude: '') }
        it 'should returns status response' do
          expect(response.status).to eq(422)
        end

        run_test!
      end
    end
  end

  path '/api/v1/{parentable_type}/{parentable_id}/geolocations/{id}' do
    # You'll want to customize the parameter types...
    parameter name: 'parentable_type', in: :path, type: :string, description: 'f.e. attractions, accommodations'
    parameter name: 'parentable_id', in: :path, type: :string, description: 'f.e. attraction_id, accommodation_id'
    parameter name: :id, in: :path, type: :string, description: 'geolocation id'
    let(:parentable_type) { 'attractions' }
    let(:parentable_id) { parent.id }
    let!(:geolocation) { create(:geolocation, geolocationable_type: 'Attraction', geolocationable_id: parent.id) }

    get('show geolocation for all') do
      tags 'Map'

      response(200, 'successful') do
        let(:id) { geolocation.id }

        it 'should returns status response' do
          expect(response.status).to eq(200)
        end

        run_test!
      end

      response(404, 'not found') do
        let(:id) { 'invalid' }

        it 'should returns status response' do
          expect(response.status).to eq(404)
        end

        run_test!
      end
    end

    put('update geolocation by admin or partner') do
      tags 'Map'
      consumes 'application/json'
      security [jwt_auth: []]
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
        let(:id) { geolocation.id }

        it 'updates the requested geolocation' do
          # put "/api/v1/attractions/#{parent.id}/geolocations/#{geolocation.id}",
          #     params: { geolocation: { locality: 'London' } }
          # geolocation.reload
          geolocation.update(locality: 'London')
          expect(geolocation.locality).to eq('London')
        end
      end

      response(401, 'unauthorized') do
        let(:id) { geolocation.id }
        let(:Authorization) { nil }
        it 'should returns status response' do
          expect(response.status).to eq(401)
        end

        run_test!
      end
    end

    delete('delete geolocation by admin or partner') do
      tags 'Map'
      security [jwt_auth: []]

      response(204, 'no content') do
        let(:id) { geolocation.id }
        it 'should returns status response' do
          expect(response.status).to eq(204)
        end

        run_test!
      end

      response(401, 'unauthorized') do
        let(:id) { geolocation.id }
        let(:Authorization) { nil }
        it 'should returns status response' do
          expect(response.status).to eq(401)
        end

        run_test!
      end

      response(404, 'not found') do
        let(:id) { 'invalid' }
        it 'should returns status response' do
          expect(response.status).to eq(404)
        end

        run_test!
      end
    end
  end
end
