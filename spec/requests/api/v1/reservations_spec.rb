require 'rails_helper'
require 'swagger_helper'

RSpec.describe 'api/v1/reservations', type: :request do
  path '/api/v1/users/{id}/reservations' do
    parameter name: 'id', in: :path, type: :string, description: 'user id'

    get('list reservation for tourist') do
      tags 'Tourist'
      produces 'application/json'
      security [ jwt_auth: [] ]
      parameter name: :archived, in: :query, schema: { type: :string },
                description: 'Archive of old reservations'

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

    post('create reservation by tourist') do
      tags 'Tourist'
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
                    catering_id: { type: :integer }
                  },
                  required: [ :number_of_peoples, :check_in, :check_out, :catering_id ]
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

  path '/api/v1/users/{user_id}/reservations/{id}' do
    parameter name: 'user_id', in: :path, type: :string, description: 'user id'
    parameter name: 'id', in: :path, type: :string, description: 'reservation id'

    get('show reservation for tourist') do
      tags 'Tourist'
      security [ jwt_auth: [] ]

      response(200, 'successful') do
        let(:user_id) { '123' }
        let(:reservation_id) { '123' }

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

    put('update reservation by tourist') do
      tags 'Tourist'
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
                    note: { type: :string }
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

    delete('delete reservation by tourist') do
      tags 'Tourist'
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

  path '/api/v1/caterings/{catering_id}/reservations/{id}/confirm' do
    parameter name: 'catering_id', in: :path, type: :string, description: 'catering_id'
    parameter name: 'id', in: :path, type: :string, description: 'reservation id'

    put('confirmations of catering reservation by partner') do
      tags 'Partner'
      consumes 'application/json'
      security [ jwt_auth: [] ]

      response(200, 'successful') do
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
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

  path '/api/v1/caterings/{catering_id}/reservations/{id}/cancel' do
    parameter name: 'catering_id', in: :path, type: :string, description: 'catering_id'
    parameter name: 'id', in: :path, type: :string, description: 'reservation id'

    put('cancelling of catering reservation by partner') do
      tags 'Partner'
      consumes 'application/json'
      security [ jwt_auth: [] ]

      response(200, 'successful') do
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
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

  path '/api/v1/caterings/{catering_id}/reservations' do
    parameter name: 'catering_id', in: :path, type: :string, description: 'catering_id'

    get('list reservations for partner') do
      tags 'Partner'
      produces 'application/json'
      security [ jwt_auth: [] ]
      parameter name: :archived, in: :query, schema: { type: :string },
                description: 'Archive of old reservations'

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
