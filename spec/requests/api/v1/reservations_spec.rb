require 'rails_helper'
require 'swagger_helper'

RSpec.describe 'api/v1/reservations', type: :request do
  let!(:partner) { create(:user, role: 'partner') }
  let(:token) { JWT.encode({ user_id: partner.id }, Rails.application.secret_key_base) }
  let(:headers) { { 'Authorization' => "Bearer #{token}" } }
  let(:Authorization) { headers['Authorization'] }
  let!(:catering) { create(:catering, user_id: partner.id) }
  let!(:geolocation) { create(:geolocation, geolocationable_type: 'Catering', geolocationable_id: catering.id) }
  let!(:user) { create(:user, email: 'tourist777@test.com') }
  let(:token) { JWT.encode({ user_id: user.id }, Rails.application.secret_key_base) }
  let(:headers) { { 'Authorization' => "Bearer #{token}" } }
  let(:Authorization) { headers['Authorization'] }

  path '/api/v1/users/{id}/reservations' do
    parameter name: 'id', in: :path, type: :string, description: 'user id'
    let(:id) { user.id }

    get('list CATERING RESERVATION for tourist') do
      tags 'Tourist Caterings'
      produces 'application/json'
      security [ jwt_auth: [] ]
      parameter name: :archived, in: :query, schema: { type: :string },
                description: 'Archive of old reservations'
      let(:archived) { nil }

      response(200, 'successful') do
        let!(:reservation) { create(:reservation, catering_id: catering.id, user_id: user.id) }

        it 'should returns status response' do
          expect(response.status).to eq(200)
        end

        run_test!
      end
    end
  end

  path '/api/v1/users/{user_id}/reservations/{id}' do
    parameter name: 'user_id', in: :path, type: :string, description: 'user id'
    parameter name: 'id', in: :path, type: :string, description: 'reservation id'
    let(:user_id) { user.id }
    let!(:reservation) { create(:reservation, catering_id: catering.id, user_id: user.id) }
    let(:id) { reservation.id }

    get('show CATERING RESERVATION for tourist') do
      tags 'Tourist Caterings'
      security [ jwt_auth: [] ]

      response(200, 'successful') do
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

    put('update CATERING RESERVATION: confirmation (approved/cancelled) - partner only, other attr. by tourist') do
      tags 'Tourist Caterings'
      consumes 'application/json'
      security [ jwt_auth: [] ]
      parameter name: :reservation,
                in: :body,
                schema: {
                  type: :object,
                  properties: {
                    number_of_peoples: { type: :integer },
                    check_in: { type: :string, format: :datetime },
                    check_out: { type: :string, format: :datetime },
                    note: { type: :string },
                    phone: { type: :string },
                    full_name: { type: :string },
                    confirmation: { type: :string }
                  }
                }

      response(200, 'successful') do
        let(:id) { reservation.id }

        run_test! do
          expect(response.status).to eq(200)
        end

        run_test! do
          reservation.update(note: 'additional table!!!')
          expect(Reservation.find_by(note: 'additional table!!!')).to eq(reservation)
          reservation.update(number_of_peoples: 12)
          expect(Reservation.find_by(number_of_peoples: 12)).to eq(reservation)
        end
      end

      response(401, 'unauthorized') do
        let(:id) { reservation.id }
        let(:Authorization) { nil }

        run_test! do |response|
          data = JSON.parse(response.body)
          reservation.update(note: 'additional table!!!')
          expect(response.status).to eq(401)
        end
      end

      response(404, 'not found') do
        let(:id) { 'invalid' }
        let(:reservation_attributes) { attributes_for(:reservation) }

        run_test! do
          expect(response.status).to eq(404)
        end
      end
    end

    delete('delete CATERING RESERVATION by tourist') do
      tags 'Tourist Caterings'
      security [ jwt_auth: [] ]

      response(200, 'successful') do
        let(:id) { reservation.id }

        run_test! do
          expect(response.status).to eq(200)
        end
      end

      response(401, 'unauthorized') do
        let(:id) { reservation.id }
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

  path '/api/v1/caterings/{catering_id}/reservations' do
    parameter name: 'catering_id', in: :path, type: :string, description: 'catering_id'
    let(:catering_id) { catering.id }

    get('list CATERING RESERVATION for partner') do
      tags 'Partner Caterings'
      produces 'application/json'
      security [ jwt_auth: [] ]
      parameter name: :archived, in: :query, schema: { type: :string },
                description: 'Archive of old reservations'
      let(:archived) { nil }

      response(200, 'successful') do
        let!(:reservation) { create(:reservation, catering_id: catering.id, user_id: user.id) }
        let(:token) { JWT.encode({ user_id: partner.id }, Rails.application.secret_key_base) }
        let(:headers) { { 'Authorization' => "Bearer #{token}" } }
        let(:Authorization) { headers['Authorization'] }

        it 'should returns status response' do
          expect(response.status).to eq(200)
        end

        run_test!
      end

      response(401, 'unauthorized') do
        let!(:reservation) { create(:reservation, catering_id: catering.id, user_id: user.id) }

        it 'should returns status response' do
          expect(response.status).to eq(401)
        end

        run_test!
      end
    end

    post('create CATERING RESERVATION by tourist') do
      tags 'Tourist Caterings'
      consumes 'application/json'
      security [ jwt_auth: [] ]
      parameter name: :reservation,
                in: :body,
                required: true,
                schema: {
                  type: :object,
                  properties: {
                    number_of_peoples: { type: :integer },
                    check_in: { type: :string, format: :datetime },
                    check_out: { type: :string, format: :datetime },
                    note: { type: :string },
                    phone: { type: :string },
                    full_name: { type: :string },
                    catering_id: { type: :integer }
                  },
                  required: [ :number_of_peoples, :check_in, :check_out, :catering_id ]
                }

      response(201, 'successful created') do
        let!(:reservation) { build(:reservation, catering_id: catering.id, user_id: user.id) }

        it 'should returns status response' do
          expect(response.status).to eq(201)
          json = JSON.parse(response.body).deep_symbolize_keys
          expect(json[:number_of_peoples]).to eq(2)
          expect(json[:phone]).to eq(reservation.phone)
          expect(json[:full_name]).to eq(reservation.full_name)
        end

        run_test!
      end

      response(401, 'unauthorized') do
        let(:Authorization) { nil }
        let!(:reservation) { build(:reservation, catering_id: catering.id, user_id: user.id) }

        it 'should returns status response' do
          expect(response.status).to eq(401)
        end

        run_test!
      end

      response(422, 'invalid request') do
        let!(:reservation) { build(:reservation, number_of_peoples: -2) }

        it 'should returns status response' do
          expect(response.status).to eq(422)
        end

        run_test!
      end
    end
  end
end
