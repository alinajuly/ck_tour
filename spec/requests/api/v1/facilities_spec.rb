require 'rails_helper'
require 'swagger_helper'

RSpec.describe 'Api::V1::Facilities', type: :request do
  let!(:user) { create(:user, role: 'partner') }
  let(:token) { JWT.encode({ user_id: user.id }, Rails.application.secret_key_base) }
  let(:headers) { { 'Authorization' => "Bearer #{token}" } }
  let(:Authorization) { headers['Authorization'] }
  let!(:accommodation) { create(:accommodation, user_id: user.id) }
  let!(:accommodation_id) { accommodation.id }

  path '/api/v1/accommodations/{accommodation_id}/facilities' do
    parameter name: 'accommodation_id', in: :path, type: :string, description: 'accommodation_id'

    get('list facilities for all') do
      tags 'Accommodation'

      response(200, 'successful') do
        it 'should returns status response' do
          expect(response.status).to eq(200)
        end

        run_test!
      end
    end

    post('create facility for accommodation by partner') do
      tags 'Partner Accommodations'
      consumes 'application/json'
      security [jwt_auth: []]
      parameter name: :facility,
                in: :body,
                required: true,
                schema: {
                  type: :object,
                  properties: {
                    checkin_start: { type: :string, format: :datetime },
                    checkin_end: { type: :string, format: :datetime },
                    checkout_start: { type: :string, format: :datetime },
                    checkout_end: { type: :string, format: :datetime },
                    credit_card: { type: :boolean },
                    free_parking: { type: :boolean },
                    wi_fi: { type: :boolean },
                    breakfast: { type: :boolean },
                    pets: { type: :boolean }
                  }
                }

      response(201, 'successful created') do
        let!(:facility) { build(:facility, accommodation_id: accommodation.id) }

        it 'should returns status response' do
          expect(response.status).to eq(201)
        end

        run_test!
      end

      response(401, 'unauthorized') do
        let!(:user) { create(:user, role: 'partner') }
        let(:Authorization) { nil }
        let!(:facility) { create(:facility, accommodation_id: accommodation.id) }

        it 'should returns status response' do
          expect(response.status).to eq(401)
        end

        run_test!
      end
    end
  end

  path '/api/v1/accommodations/{accommodation_id}/facilities/{id}' do
    parameter name: 'accommodation_id', in: :path, type: :string, description: 'accommodation_id'
    parameter name: 'id', in: :path, type: :string, description: 'facility_id'

    let(:Authorization) { headers['Authorization'] }
    let!(:accommodation) { create(:accommodation, user_id: user.id) }
    let!(:accommodation_id) { accommodation.id }
    let!(:facility) { create(:facility, accommodation_id: accommodation.id) }
    let(:id) { facility.id }

    put('update facility of accommodation by partner') do
      tags 'Partner Accommodations'
      consumes 'application/json'
      security [jwt_auth: []]
      parameter name: :facility,
                in: :body,
                schema: {
                  type: :object,
                  properties: {
                    checkin_start: { type: :string, format: :datetime },
                    checkin_end: { type: :string, format: :datetime },
                    checkout_start: { type: :string, format: :datetime },
                    checkout_end: { type: :string, format: :datetime },
                    credit_card: { type: :boolean },
                    free_parking: { type: :boolean },
                    wi_fi: { type: :boolean },
                    breakfast: { type: :boolean },
                    pets: { type: :boolean }
                  }
                }

      response(200, 'successful') do
        it 'should returns status response' do
          expect(response.status).to eq(200)
        end

        run_test!
      end

      response(401, 'unauthorized') do
        let!(:user) { create(:user, role: 'partner') }
        let(:Authorization) { nil }

        it 'should returns status response' do
          expect(response.status).to eq(401)
        end

        run_test!
      end
    end

    delete('delete facility of accommodation by partner') do
      tags 'Partner Accommodations'
      security [jwt_auth: []]

      response(200, 'successful') do
        it 'should returns status response' do
          expect(response.status).to eq(200)
        end

        run_test!
      end

      response(401, 'unauthorized') do
        let!(:user) { create(:user, role: 'partner') }
        let(:Authorization) { nil }

        it 'should returns status response' do
          expect(response.status).to eq(401)
        end

        run_test!
      end
    end
  end
end
