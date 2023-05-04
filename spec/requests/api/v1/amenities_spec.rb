require 'rails_helper'
require 'swagger_helper'

RSpec.describe "Api::V1::Amenities", type: :request do
  let!(:user) { create(:user, role: 'partner') }
  let(:token) { JWT.encode({ user_id: user.id }, Rails.application.secret_key_base) }
  let(:headers) { { 'Authorization' => "Bearer #{token}" } }

  path '/api/v1/accommodations/{accommodation_id}/rooms/{room_id}/amenities' do
    parameter name: 'accommodation_id', in: :path, type: :string, description: 'accommodation_id'
    parameter name: 'room_id', in: :path, type: :string, description: 'room_id'
    get('list amenities of room') do
      tags 'Accommodation'

      response(200, 'successful') do
        let(:Authorization) { headers['Authorization'] }
        let!(:accommodation) { create(:accommodation, user_id: user.id) }
        let!(:room) { create(:room, accommodation_id: accommodation.id) }
        let!(:accommodation_id) { accommodation.id }
        let!(:room_id) { room.id }

        it 'should returns status response' do
          expect(response.status).to eq(200)
        end

        run_test!
      end

      response(404, 'not found') do
        let(:Authorization) { headers['Authorization'] }
        let!(:accommodation) { create(:accommodation, user_id: user.id) }
        let!(:room) { create(:room, accommodation_id: accommodation.id) }
        let!(:accommodation_id) { 'invalid' }
        let!(:room_id) { 'invalid' }

        it 'should returns status response' do
          expect(response.status).to eq(404)
        end

        run_test!
      end
    end

    post('create amenity of room - for partner only') do
      tags 'Partner Accommodations'
      consumes 'application/json'
      security [ jwt_auth: [] ]
      parameter name: :amenity,
                in: :body,
                required: true,
                schema: {
                  type: :object,
                  properties: {
                    conditioner: { type: :boolean },
                    tv: { type: :boolean },
                    refrigerator: { type: :boolean },
                    kettle: { type: :boolean },
                    mv_owen: { type: :boolean },
                    hair_dryer: { type: :boolean },
                    nice_view: { type: :boolean },
                    inclusive: { type: :boolean }
                  },
                }

      response(201, 'successful created') do
        let(:Authorization) { headers['Authorization'] }
        let!(:accommodation) { create(:accommodation, user_id: user.id) }
        let!(:room) { create(:room, accommodation_id: accommodation.id) }
        let!(:accommodation_id) { accommodation.id }
        let!(:room_id) { room.id }
        let!(:amenity) { build(:amenity, room_id: room.id) }
        
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
        let!(:accommodation) { create(:accommodation, user_id: user.id) }
        let!(:room) { create(:room, accommodation_id: accommodation.id) }
        let!(:accommodation_id) { accommodation.id }
        let!(:room_id) { room.id }
        let!(:amenity) { build(:amenity, room_id: room.id) }

        it 'should returns status response' do
          expect(response.status).to eq(401)
        end

        run_test!
      end

      response(404, 'not found') do
        let(:Authorization) { headers['Authorization'] }
        let!(:accommodation) { create(:accommodation, user_id: user.id) }
        let!(:room) { create(:room, accommodation_id: accommodation.id) }
        let!(:accommodation_id) { 'invalid' }
        let!(:room_id) { 'invalid' }
        let!(:amenity) { build(:amenity, room_id: room.id) }

        it 'should returns status response' do
          expect(response.status).to eq(404)
        end

        run_test!
      end
    end
  end

  path '/api/v1/accommodations/{accommodation_id}/rooms/{room_id}/amenities/{id}' do
    parameter name: 'accommodation_id', in: :path, type: :string, description: 'accommodation_id'
    parameter name: 'room_id', in: :path, type: :string, description: 'room_id'
    parameter name: 'id', in: :path, type: :string, description: 'amenity_id'

    let(:Authorization) { headers['Authorization'] }
    let!(:accommodation) { create(:accommodation, user_id: user.id) }
    let!(:room) { create(:room, accommodation_id: accommodation.id) }
    let!(:accommodation_id) { accommodation.id }
    let!(:room_id) { room.id }
    let!(:amenity) { create(:amenity, room_id: room.id) }

    put('update amenity of room - for partner only') do
      tags 'Partner Accommodations'
      consumes 'application/json'
      security [ jwt_auth: [] ]
      parameter name: :amenity,
                in: :body,
                schema: {
                  type: :object,
                  properties: {
                    conditioner: { type: :boolean },
                    tv: { type: :boolean },
                    refrigerator: { type: :boolean },
                    kettle: { type: :boolean },
                    mv_owen: { type: :boolean },
                    hair_dryer: { type: :boolean },
                    nice_view: { type: :boolean },
                    inclusive: { type: :boolean }
                  }
                }

      response(200, 'successful') do
        let(:id) { amenity.id }

        it 'should returns status response' do
          expect(response.status).to eq(200)
        end

        run_test!
      end

      response(401, 'unauthorized') do
        let!(:user) { create(:user) }
        let(:token) { JWT.encode({ user_id: user.id }, Rails.application.secret_key_base) }
        let(:headers) { { 'Authorization' => "Bearer #{token}" } }
        let(:Authorization) { headers['Authorization'] }
        let!(:accommodation) { create(:accommodation, user_id: user.id) }
        let!(:room) { create(:room, accommodation_id: accommodation.id) }
        let!(:accommodation_id) { accommodation.id }
        let!(:room_id) { room.id }
        let!(:amenity) { create(:amenity, room_id: room.id) }
        let(:id) { amenity.id }
        
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

    delete('delete amenity of room - for partner only') do
      tags 'Partner Accommodations'
      security [ jwt_auth: [] ]

      response(200, 'successful') do
        let!(:accommodation_id) { accommodation.id }
        let(:id) { amenity.id }

        it 'should returns status response' do
          expect(response.status).to eq(200)
        end

        run_test!
      end

      response(401, 'unauthorized') do
        let!(:user) { create(:user) }
        let(:token) { JWT.encode({ user_id: user.id }, Rails.application.secret_key_base) }
        let(:headers) { { 'Authorization' => "Bearer #{token}" } }
        let(:Authorization) { headers['Authorization'] }
        let(:id) { amenity.id }

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
