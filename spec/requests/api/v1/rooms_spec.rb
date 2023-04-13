require 'rails_helper'
require 'swagger_helper'

RSpec.describe 'api/v1/rooms', type: :request do
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
        let(:accommodation_id) { '1' }

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

  path '/api/v1/accommodations/{accommodation_id}/rooms/{id}' do
    parameter name: 'accommodation_id', in: :path, type: :string, description: 'accommodation_id'
    parameter name: 'id', in: :path, type: :string, description: 'room_id'

    get('show room of accommodation for all') do
      tags 'Accommodation'

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
        let(:accommodation_id) { '123' }
        let(:room_id) { '123' }

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

    delete('delete room of accommodation by partner') do
      tags 'Partner Accommodations'
      security [jwt_auth: []]

      response(200, 'successful') do
        let(:accommodation_id) { '123' }
        let(:room_id) { '123' }

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
