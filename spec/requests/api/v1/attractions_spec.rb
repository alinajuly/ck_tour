require 'rails_helper'
require 'swagger_helper'

RSpec.describe 'api/v1/attractions', type: :request do
  let!(:user) { create(:user, role: 'admin') }
  let(:token) { JWT.encode({ user_id: user.id }, Rails.application.secret_key_base) }
  let(:headers) { { 'Authorization' => "Bearer #{token}" } }
  let(:Authorization) { headers['Authorization'] }

  path '/api/v1/attractions' do
    get('list attractions for all') do
      tags 'Attraction'
      produces 'application/json'
      parameter name: :geolocations, in: :query, schema: { type: :string },
                description: 'Locality'
      parameter name: :search, in: :query, schema: { type: :string },
                description: 'Search'

      let!(:attraction1) { create(:attraction) }
      let!(:attraction2) { create(:attraction, title: 'Niagara Falls') }
      let(:geolocations) { nil }
      let(:search) { 'Niagara' }

      response(200, 'successful') do
        it 'should returns status response' do
          expect(response.status).to eq(200)
        end

        run_test!
      end
    end

    post('create attraction by admin') do
      tags 'Admin Attractions'
      description 'Creates a new attraction'
      security [jwt_auth: []]
      consumes 'multipart/form-data'
      parameter name: :attraction,
                # in: :body,
                in: :formData,
                required: true,
                schema: {
                  type: :object,
                  properties: {
                    title: { type: :string },
                    description: { type: :string },
                    image: { type: :file }
                  },
                  required: %i[title description image]
                }

      response(201, 'successful created') do
        let(:Authorization) { headers['Authorization'] }
        let(:attraction) { FactoryBot.attributes_for(:attraction) }

        run_test! do
          expect(response.status).to eq(201)
          json = JSON.parse(response.body).deep_symbolize_keys
          expect(json[:title]).to eq(attraction.title)
          expect(json[:description]).to eq(attraction.description)
        end
      end

      response(401, 'unauthorized') do
        let!(:user) { create(:user) }
        let(:token) { JWT.encode({ user_id: user.id }, Rails.application.secret_key_base) }
        let(:headers) { { 'Authorization' => "Bearer #{token}" } }
        let(:Authorization) { headers['Authorization'] }
        let!(:attraction) { { title: 'Test Attraction', description: 'A test attraction' } }

        run_test! do
          expect(response.status).to eq(401)
        end
      end

      response '422', 'unprocessable entity' do
        let(:Authorization) { headers['Authorization'] }
        let!(:attraction) { { title: '', description: 'A test attraction' } }

        run_test! do
          expect(response.status).to eq(422)
        end
      end
    end
  end

  path '/api/v1/attractions/{id}' do
    # You'll want to customize the parameter types...
    parameter name: :id, in: :path, type: :string, description: 'attraction id'
    let(:Authorization) { headers['Authorization'] }
    let!(:attraction) { create(:attraction) }

    get('show attraction for all') do
      tags 'Attraction'

      response(200, 'successful') do
        let(:id) { attraction.id }

        run_test! do
          expect(response.status).to eq(200)
        end
      end

      response(404, 'not found') do
        let(:id) { 'invalid' }

        run_test! do
          expect(response.status).to eq(404)
        end
      end
    end

    put('update attraction by admin') do
      tags 'Admin Attractions'
      security [jwt_auth: []]
      consumes 'multipart/form-data'
      parameter name: :attraction,
                in: :formData,
                schema: {
                  type: :object,
                  properties: {
                    title: { type: :string },
                    description: { type: :string },
                    image: { type: :file }
                  }
                }

      response(200, 'successful') do
        let(:id) { attraction.id }

        it 'returns a 200 response' do
          expect(response).to have_http_status(:ok)
        end

        run_test! do
          attraction.update(title: 'Niagara Falls')
          expect(Attraction.find_by(title: 'Niagara Falls')).to eq(attraction)
          attraction.update(description: 'Really Niagara Falls')
          expect(Attraction.find_by(description: 'Really Niagara Falls')).to eq(attraction)
        end
      end

      response(401, 'unauthorized') do
        let!(:user) { create(:user) }
        let(:token) { JWT.encode({ user_id: user.id }, Rails.application.secret_key_base) }
        let(:headers) { { 'Authorization' => "Bearer #{token}" } }
        let(:Authorization) { headers['Authorization'] }
        let(:id) { attraction.id }

        run_test! do
          expect(response.status).to eq(401)
        end
      end

      response(404, 'not found') do
        let(:id) { 'invalid' }

        run_test! do
          expect(response.status).to eq(404)
        end
      end
    end

    delete('delete attraction by admin') do
      tags 'Admin Attractions'
      security [jwt_auth: []]

      response(200, 'successful') do
        let(:id) { attraction.id }

        run_test! do
          expect(response.status).to eq(200)
        end
      end

      response(401, 'unauthorized') do
        let!(:user) { create(:user) }
        let(:token) { JWT.encode({ user_id: user.id }, Rails.application.secret_key_base) }
        let(:headers) { { 'Authorization' => "Bearer #{token}" } }
        let(:Authorization) { headers['Authorization'] }
        let(:id) { attraction.id }

        run_test! do
          expect(response.status).to eq(401)
        end
      end

      response(404, 'not found') do
        let(:id) { 'invalid' }

        run_test! do
          expect(response.status).to eq(404)
        end
      end
    end
  end
end
