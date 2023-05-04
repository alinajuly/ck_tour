require 'rails_helper'
require 'swagger_helper'

RSpec.describe 'api/v1/rooms', type: :request do
  let!(:user) { create(:user, role: 'partner') }
  let(:token) { JWT.encode({ user_id: user.id }, Rails.application.secret_key_base) }
  let(:headers) { { 'Authorization' => "Bearer #{token}" } }
  let(:Authorization) { headers['Authorization'] }
  let!(:accommodation) { create(:accommodation, user_id: user.id) }
  let!(:accommodation_id) { accommodation.id }

  path '/api/v1/accommodations/{accommodation_id}/rooms' do
    parameter name: 'accommodation_id', in: :path, type: :string, description: 'accommodation_id'
    get('list rooms of accommodation for all') do
      tags 'Accommodation'
      produces 'application/json'
      parameter name: :check_in, in: :query, schema: { type: :string },
                description: 'Guests Check-in f.e. 2023-05-15'
      parameter name: :check_out, in: :query, schema: { type: :string },
                description: 'Guests Check-out f.e. 2023-05-17'
      parameter name: :number_of_peoples, in: :query, schema: { type: :string },
                description: 'Guests quantity'

      response(200, 'successful') do
        let(:check_in) { Time.now + 3.days }
        let(:check_out) { Time.now + 7.days }
        let(:number_of_peoples) { 2 }
        let!(:room) { build(:room, accommodation_id: accommodation.id) }

        it 'should returns status response' do
          expect(response.status).to eq(200)
        end

        run_test!
      end
    end

    post('create room of accommodation by partner') do
      tags 'Partner Accommodations'
      security [jwt_auth: []]
      consumes 'multipart/form-data'
      parameter name: :room,
                in: :formData,
                required: true,
                schema: {
                  type: :object,
                  properties: {
                    name: { type: :string },
                    places: { type: :integer },
                    quantity: { type: :integer },
                    description: { type: :string },
                    bed: { type: :string },
                    price_per_night: { type: :integer },
                    'images[]':
                    {
                      type: :array,
                      items:
                        { type: :string,
                          format: :binary }
                    }
                  },
                  required: %i[name places bed description quantity price_per_night]
                }

      response(201, 'successful created') do
        let(:Authorization) { headers['Authorization'] }
        let!(:accommodation) { create(:accommodation, user_id: user.id) }
        let!(:accommodation_id) { accommodation.id }
        let!(:room) { create(:room, accommodation_id: accommodation.id) }

        it 'should returns status response' do
          expect(response.status).to eq(201)
        end

        run_test!
      end

      response(401, 'unauthorized') do
        let!(:user) { create(:user) }
        let(:token) { JWT.encode({ user_id: user.id }, Rails.application.secret_key_base) }
        let(:headers) { { 'Authorization' => "Bearer #{token}" } }
        let(:Authorization) { headers['Authorization'] }
        let!(:room) { create(:room, accommodation_id: accommodation.id) }

        it 'should returns status response' do
          expect(response.status).to eq(401)
        end

        run_test!
      end

      response(422, 'invalid request') do
        let!(:room) { build(:room, accommodation_id: accommodation.id, name: nil) }

        it 'should returns status response' do
          expect(response.status).to eq(422)
        end

        run_test!
      end
    end
  end

  path '/api/v1/accommodations/{accommodation_id}/rooms/{id}' do
    parameter name: 'accommodation_id', in: :path, type: :string, description: 'accommodation_id'
    parameter name: 'id', in: :path, type: :string, description: 'room_id'

    let!(:room) { create(:room, accommodation_id: accommodation.id) }

    get('show room of accommodation for all') do
      tags 'Accommodation'

      response(200, 'successful') do
        let(:id) { room.id }

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

    put('update room of accommodation by partner') do
      tags 'Partner Accommodations'
      consumes 'multipart/form-data'
      security [jwt_auth: []]
      parameter name: :room,
                in: :formData,
                schema: {
                  type: :object,
                  properties: {
                    name: { type: :string },
                    places: { type: :integer },
                    quantity: { type: :integer },
                    description: { type: :string },
                    bed: { type: :string },
                    price_per_night: { type: :integer },
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
        let(:id) { room.id }

        it 'should returns status response' do
          expect(response.status).to eq(200)
        end

        run_test!
      end

      response(401, 'unauthorized') do
        let(:Authorization) { nil }
        let(:id) { room.id }

        it 'should returns status response' do
          expect(response.status).to eq(401)
        end

        run_test!
      end

      response(404, 'not found') do
        let(:id) { 'invalid' }
        let(:room_attributes) { attributes_for(:room) }

        it 'should returns status response' do
          expect(response.status).to eq(404)
        end

        run_test!
      end
    end

    delete('delete room of accommodation by partner') do
      tags 'Partner Accommodations'
      security [jwt_auth: []]

      response(200, 'successful') do
        let(:id) { room.id }

        it 'should returns status response' do
          expect(response.status).to eq(200)
        end

        run_test!
      end

      response(401, 'unauthorized') do
        let(:id) { room.id }
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
