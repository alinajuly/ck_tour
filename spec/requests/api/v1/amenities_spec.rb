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
        let!(:Authorization) { headers['Authorization'] }
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
        it 'should returns status response' do
          expect(response.status).to eq(404)
        end

        run_test!
      end

      response(422, 'invalid request') do
        it 'should returns status response' do
          expect(response.status).to eq(422)
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
        let(:accommodation_id) { '123' }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end

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

  path '/api/v1/accommodations/{accommodation_id}/rooms/{room_id}/amenities/{id}' do
    parameter name: 'accommodation_id', in: :path, type: :string, description: 'accommodation_id'
    parameter name: 'room_id', in: :path, type: :string, description: 'room_id'
    parameter name: 'id', in: :path, type: :string, description: 'amenity_id'

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
        let(:accommodation_id) { '123' }
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

    delete('delete amenity of room - for partner only') do
      tags 'Partner Accommodations'
      security [ jwt_auth: [] ]

      response(200, 'successful') do
        let(:accommodation_id) { '123' }
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
