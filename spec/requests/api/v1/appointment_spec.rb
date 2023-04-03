require 'rails_helper'
require 'swagger_helper'

RSpec.describe 'api/v1/appointments', type: :request do

  path '/api/v1/users/{id}/appointments' do
    parameter name: 'id', in: :path, type: :string, description: 'user id'

    get('list tour appointment for tourist') do
      tags 'Tourist'
      produces 'application/json'
      security [ jwt_auth: [] ]
      parameter name: :archived, in: :query, schema: { type: :string },
                description: 'Archive of old appointments'

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

    post('create tour appointment by tourist') do
      tags 'Tourist'
      consumes 'application/json'
      security [ jwt_auth: [] ]
      parameter name: :appointment,
                in: :body,
                required: true,
                schema: {
                  type: :object,
                  properties: {
                    number_of_peoples: { type: :integer },
                    tour_id: { type: :integer }
                  },
                  required: [ :number_of_peoples, :tour_id ]
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

  path '/api/v1/users/{user_id}/appointments/{id}' do
    parameter name: 'user_id', in: :path, type: :string, description: 'user id'
    parameter name: 'id', in: :path, type: :string, description: 'appointment id'

    get('show tour appointment for tourist') do
      tags 'Tourist'
      security [ jwt_auth: [] ]

      response(200, 'successful') do
        let(:user_id) { '123' }
        let(:appointment_id) { '123' }

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

    put('update tour appointment by tourist') do
      tags 'Tourist'
      consumes 'application/json'
      security [ jwt_auth: [] ]
      parameter name: :appointment,
                in: :body,
                schema: {
                  type: :object,
                  properties: {
                    number_of_peoples: { type: :integer }
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

    delete('delete tour appointment by tourist') do
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

  path '/api/v1/tours/{tour_id}/appointments/{id}/confirm' do
    parameter name: 'tour_id', in: :path, type: :string, description: 'tour id'
    parameter name: 'id', in: :path, type: :string, description: 'appointment id'

    put('confirmations of tour appointment for partner') do
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

  path '/api/v1/tours/{tour_id}/appointments/{id}/cancel' do
    parameter name: 'tour_id', in: :path, type: :string, description: 'tour id'
    parameter name: 'id', in: :path, type: :string, description: 'appointment id'

    put('cancelling of tour appointment for partner') do
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

  path '/api/v1/tours/{tour_id}/appointments' do
    parameter name: 'tour_id', in: :path, type: :string, description: 'tour id'

    get('list appointments of tour for partner') do
      tags 'Partner'
      produces 'application/json'
      security [ jwt_auth: [] ]
      parameter name: :archived, in: :query, schema: { type: :string },
                description: 'Archive of old appointments'

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
