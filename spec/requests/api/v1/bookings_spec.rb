require 'rails_helper'
require 'swagger_helper'

RSpec.describe 'api/v1/bookings', type: :request do
  let!(:partner) { create(:user, role: 'partner') }
  let(:token) { JWT.encode({ user_id: partner.id }, Rails.application.secret_key_base) }
  let(:headers) { { 'Authorization' => "Bearer #{token}" } }
  let(:Authorization) { headers['Authorization'] }
  let!(:accommodation) { create(:accommodation, user_id: partner.id) }
  let!(:accommodation_id) { accommodation.id }
  let!(:room) { create(:room, accommodation_id: accommodation.id) }
  let!(:room_id) { room.id }
  let!(:geolocation) { create(:geolocation, geolocationable_type: 'Accommodation', geolocationable_id: accommodation.id) }
  let!(:user) { create(:user, role: 'tourist', email: 'testemail@example.com') }
  let(:token) { JWT.encode({ user_id: user.id }, Rails.application.secret_key_base) }
  let(:headers) { { 'Authorization' => "Bearer #{token}" } }
  let(:Authorization) { headers['Authorization'] }

  path '/api/v1/users/{id}/bookings' do
    parameter name: 'id', in: :path, type: :string, description: 'user id'
    let(:id) { user.id }

    get('list ACCOMMODATION BOOKING for tourist') do
      tags 'Tourist Accommodations'
      produces 'application/json'
      security [ jwt_auth: [] ]
      parameter name: :archived, in: :query, schema: { type: :string },
                description: 'Archive of old bookings'

      let(:archived) { nil }

      response(200, 'successful') do
        let!(:booking) { create(:booking, room_id: room.id, user_id: user.id) }

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

  path '/api/v1/users/{user_id}/bookings/{id}' do
    parameter name: 'user_id', in: :path, type: :string, description: 'user id'
    parameter name: 'id', in: :path, type: :string, description: 'booking id'

    get('show ACCOMMODATION BOOKING for tourist') do
      tags 'Tourist Accommodations'
      security [ jwt_auth: [] ]

      response(200, 'successful') do
        let(:user_id) { '123' }
        let(:booking_id) { '123' }

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

    put('update ACCOMMODATION BOOKING: confirmation (approved/cancelled) - partner only, other attr. by tourist') do
      tags 'Tourist Accommodations'
      consumes 'application/json'
      security [ jwt_auth: [] ]
      parameter name: :booking,
                in: :body,
                schema: {
                  type: :object,
                  properties: {
                    number_of_peoples: { type: :integer },
                    check_in: { type: :string, format: :date },
                    check_out: { type: :string, format: :date },
                    note: { type: :string },
                    phone: { type: :string },
                    full_name: { type: :string },
                    confirmation: { type: :string }
                  }
                }

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

    delete('delete ACCOMMODATION BOOKING by tourist') do
      tags 'Tourist Accommodations'
      security [ jwt_auth: [] ]

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

  path '/api/v1/accommodations/{accommodation_id}/rooms/{room_id}/bookings' do
    parameter name: 'accommodation_id', in: :path, type: :string, description: 'accommodation_id'
    parameter name: 'room_id', in: :path, type: :string, description: 'room_id'

    get('list ACCOMMODATION BOOKING for partner') do
      tags 'Partner Accommodations'
      produces 'application/json'
      security [ jwt_auth: [] ]
      parameter name: :archived, in: :query, schema: { type: :string },
                description: 'Archive of old bookings'

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

    post('create ACCOMMODATION BOOKING by tourist') do
      tags 'Tourist Accommodations'
      consumes 'application/json'
      security [ jwt_auth: [] ]
      parameter name: :booking,
                in: :body,
                required: true,
                schema: {
                  type: :object,
                  properties: {
                    number_of_peoples: { type: :integer },
                    check_in: { type: :string, format: :date },
                    check_out: { type: :string, format: :date },
                    note: { type: :string },
                    phone: { type: :string },
                    full_name: { type: :string },
                    room_id: { type: :integer }
                  },
                  required: [ :number_of_peoples, :check_in, :check_out, :room_id ]
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
end
