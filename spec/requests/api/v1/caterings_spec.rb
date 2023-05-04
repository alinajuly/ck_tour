require 'rails_helper'
require 'swagger_helper'

RSpec.describe 'api/v1/caterings', type: :request do
  let!(:user) { create(:user, role: 'partner') }
  let(:token) { JWT.encode({ user_id: user.id }, Rails.application.secret_key_base) }
  let(:headers) { { 'Authorization' => "Bearer #{token}" } }

  path '/api/v1/caterings' do
    get('list CATERING - published for all') do
      tags 'Catering'
      produces 'application/json'
      security [jwt_auth: []]
      parameter name: :geolocations, in: :query, schema: { type: :string },
                description: 'Locality'
      parameter name: :user_id, in: :query, schema: { type: :integer },
                description: 'Filter on partner'
      parameter name: :status, in: :query, schema: { type: :string },
                description: 'Filter on status: unpublished/published'
      parameter name: :check_in, in: :query, schema: { type: :string },
                description: 'Guests Check-in f.e. 2023-05-15-18-00'
      parameter name: :check_out, in: :query, schema: { type: :string },
                description: 'Guests Check-out f.e. 2023-05-15-21-00'
      parameter name: :number_of_peoples, in: :query, schema: { type: :string },
                description: 'Guests quantity'

      let(:Authorization) { headers['Authorization'] }
      let!(:catering1) { create(:catering, user_id: user.id, name: 'Restaurant 1') }
      let!(:catering2) { create(:catering, user_id: user.id, name: 'Restaurant 2') }
      let(:geolocations) { nil }
      let(:check_in) { Time.now + 3.hours }
      let(:check_out) { Time.now + 7.hours }
      let(:number_of_peoples) { 2 }
      let(:user_id) { nil }
      let(:status) { 'unpublished' }

      before do
        allow_any_instance_of(Api::V1::CateringsController).to receive(:available_caterings).and_return([catering1])
      end

      response(200, 'successful') do
        it 'should returns status response' do
          expect(response.status).to eq(200)
        end

        run_test!
      end
    end

    post('create new CATERING - for partner only') do
      tags 'Partner Caterings'
      description 'Creates a new catering'
      consumes 'multipart/form-data'
      security [jwt_auth: []]
      parameter name: :catering,
                in: :formData,
                required: true,
                schema: {
                  type: :object,
                  properties: {
                    name: { type: :string },
                    description: { type: :string },
                    places: { type: :integer },
                    kind: { type: :string },
                    phone: { type: :string },
                    email: { type: :string },
                    address_owner: { type: :string },
                    reg_code: { type: :string },
                    person: { type: :string },
                    user_id: { type: :string },
                    'images[]':
                      {
                        type: :array,
                        items:
                          { type: :string,
                            format: :binary }
                      }
                  },
                  required: %i[name description places address_owner phone email kind
                               user_id reg_code person]
                }

      response(201, 'successful created') do
        let(:Authorization) { headers['Authorization'] }
        let!(:catering) { build_stubbed(:catering, name: 'Abscdgytraed', user_id: user.id) }

        run_test! do
          expect(Catering.find_by(name: 'Abscdgytraed')).to eq(catering)
          expect(response.status).to eq(201)
        end
      end

      response(401, 'unauthorized') do
        let(:Authorization) { nil }
        let!(:catering) { build(:catering, user_id: user.id) }

        run_test! do
          expect(response.status).to eq(401)
        end
      end

      response(422, 'invalid request') do
        let(:Authorization) { headers['Authorization'] }
        let!(:catering) do
          { name: 'Test Catering', description: 'A test catering', kind: 'cafe', user_id: user.id }
        end

        run_test! do
          expect(response.status).to eq(422)
        end
      end
    end
  end

  path '/api/v1/caterings/{id}' do
    parameter name: :id, in: :path, type: :string, description: 'catering id'
    let(:Authorization) { headers['Authorization'] }
    let!(:catering) { create(:catering, user_id: user.id) }

    get('show CATERING - published for all') do
      tags 'Catering'
      security [jwt_auth: []]

      response(200, 'successful') do
        let(:id) { catering.id }

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

    put('update CATERING: status by admin: published/unpublished , other attr. by partner his own only') do
      tags 'Partner Caterings'
      consumes 'multipart/form-data'
      security [jwt_auth: []]
      parameter name: :catering,
                in: :formData,
                schema: {
                  type: :object,
                  properties: {
                    name: { type: :string },
                    description: { type: :string },
                    places: { type: :integer },
                    kind: { type: :string },
                    phone: { type: :string },
                    email: { type: :string },
                    address_owner: { type: :string },
                    reg_code: { type: :string },
                    person: { type: :string },
                    status: { type: :string },
                    'images[]':
                      {
                        type: :array,
                        items:
                          { type: :string,
                            format: :binary }
                      }
                  }
                }

      response(200, 'successful') do
        let(:id) { catering.id }

        it 'returns a 200 response' do
          expect(response).to have_http_status(:ok)
        end

        run_test! do |response|
          data = JSON.parse(response.body)
          catering.update(name: 'The newest restaurant of Ukrainian cuisine')
          expect(Catering.find_by(name: 'The newest restaurant of Ukrainian cuisine')).to eq(catering)
          catering.update(description: 'The most delicious dishes')
          expect(Catering.find_by(description: 'The most delicious dishes')).to eq(catering)
        end
      end

      response(401, 'unauthorized') do
        let(:id) { catering.id }
        let!(:user) { create(:user) }
        let(:token) { JWT.encode({ user_id: user.id }, Rails.application.secret_key_base) }
        let(:headers) { { 'Authorization' => "Bearer #{token}" } }
        let(:Authorization) { headers['Authorization'] }

        run_test! do |response|
          data = JSON.parse(response.body)
          catering.update(name: 'The newest restaurant of Ukrainian cuisine')
          expect(response.status).to eq(401)
        end
      end

      response(404, 'not found') do
        let(:id) { 'invalid' }
        let(:catering_attributes) { attributes_for(:catering) }

        run_test! do
          expect(response.status).to eq(404)
        end
      end
    end

    delete('delete CATERING - for admin all, for partner his own only') do
      tags 'Partner Caterings'
      security [jwt_auth: []]

      response(200, 'ok') do
        let(:id) { catering.id }

        run_test! do
          expect(response.status).to eq(200)
        end
      end

      response(401, 'unauthorized') do
        let(:id) { catering.id }
        let(:Authorization) { nil }

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
