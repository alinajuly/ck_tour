require 'rails_helper'
require 'swagger_helper'

RSpec.describe 'api/v1/rates', type: :request do
  let!(:admin) { create(:user, role: 'admin') }
  let(:token) { JWT.encode({ user_id: admin.id }, Rails.application.secret_key_base) }
  let(:headers) { { 'Authorization' => "Bearer #{token}" } }
  let(:Authorization) { headers['Authorization'] }
  let!(:parent) { create(:attraction) }
  let!(:user) { create(:user, email: 'new_tourist@test.com') }
  let(:token) { JWT.encode({ user_id: user.id }, Rails.application.secret_key_base) }
  let(:headers) { { 'Authorization' => "Bearer #{token}" } }
  let(:Authorization) { headers['Authorization'] }

  path '/api/v1/{parentable_type}/{parentable_id}/rates' do
    parameter name: 'parentable_type', in: :path, type: :string,
              description: 'f.e. attractions, accommodations, caterings, tours'
    parameter name: 'parentable_id', in: :path, type: :string,
              description: 'f.e. attraction_id, accommodation_id, catering_id, tour_id'
    let(:parentable_type) { 'attractions' }
    let(:parentable_id) { parent.id }

    get('averedge rate for all') do
      tags 'Rate'
      produces 'application/json'
      security [jwt_auth: []]
      let!(:rate) { create(:rate, ratable_id: parent.id, user_id: user.id) }

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

    post('create rate by authenticated user') do
      tags 'Rate'
      consumes 'application/json'
      security [jwt_auth: []]
      parameter name: :rate,
                in: :body,
                required: true,
                schema: {
                  type: :object,
                  properties: {
                    rating: { type: :integer }
                  },
                  required: %i[rating]
                }
      let(:rate) { FactoryBot.attributes_for(:rate) }

      response(201, 'successful created') do
        it 'should returns status response' do
          expect(response.status).to eq(201)
          json = JSON.parse(response.body).deep_symbolize_keys
          expect(json[:rating]).to eq(5)
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
        let(:rate) { FactoryBot.attributes_for(:rate, rating: -2) }
        it 'should returns status response' do
          expect(response.status).to eq(422)
        end

        run_test!
      end
    end
  end

  path '/api/v1/{parentable_type}/{parentable_id}/rates/{id}' do
    parameter name: 'parentable_type', in: :path, type: :string,
              description: 'f.e. attractions, accommodations, caterings, tours'
    parameter name: 'parentable_id', in: :path, type: :string,
              description: 'f.e. attraction_id, accommodation_id, catering_id, tour_id'
    parameter name: :id, in: :path, type: :string, description: 'rate id'
    let(:parentable_type) { 'attractions' }
    let(:parentable_id) { parent.id }
    let!(:rate) { create(:rate, ratable_id: parent.id, user_id: user.id) }

    get('show rate for all') do
      tags 'Rate'
      security [jwt_auth: []]

      response(200, 'successful') do
        let(:id) { rate.id }

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

    put('update rate by authenticated user or admin') do
      tags 'Rate'
      consumes 'application/json'
      security [jwt_auth: []]
      parameter name: :rate,
                in: :body,
                schema: {
                  type: :object,
                  properties: {
                    rating: { type: :integer }
                  },
                  required: %i[rating]
                }

      response(200, 'successful') do
        let(:id) { rate.id }

        it 'updates the requested rate' do
          rate.update(rating: 4)
          expect(rate.rating).to eq(4)
        end
      end

      response(401, 'unauthorized') do
        let(:Authorization) { nil }
        let(:id) { rate.id }
        it 'should returns status response' do
          expect(response.status).to eq(401)
        end

        run_test!
      end
    end

    delete('delete rate by admin') do
      tags 'Rate'
      security [jwt_auth: []]
      let!(:admin) { create(:user, role: 'admin') }
      let(:token) { JWT.encode({ user_id: admin.id }, Rails.application.secret_key_base) }
      let(:headers) { { 'Authorization' => "Bearer #{token}" } }
      let(:Authorization) { headers['Authorization'] }

      response(200, 'Successful') do
        let(:id) { rate.id }
        it 'should returns status response' do
          expect(response.status).to eq(200)
        end

        run_test!
      end

      response(401, 'unauthorized') do
        let(:id) { rate.id }
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
