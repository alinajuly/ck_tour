require 'rails_helper'
require 'swagger_helper'

RSpec.describe 'api/v1/places', type: :request do
  path '/api/v1/tours/{tour_id}/places' do
    parameter name: 'tour_id', in: :path, type: :string, description: 'tour_id'
    get('list places of tour for all') do
      tags 'Tour'
      produces 'application/json'
      security [ jwt_auth: [] ]

      response(200, 'successful') do
        let(:tour_id) { '1' }

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

    post('create place for tour by partner') do
      tags 'Partner Tours'
      security [jwt_auth: []]
      consumes 'multipart/form-data'
      parameter name: :place,
                in: :formData,
                required: true,
                schema: {
                  type: :object,
                  properties: {
                    name: { type: :string },
                    body: { type: :string },
                    image: { type: :file }
                  },
                  required: %i[name body image]
                }

      response(201, 'successful created') do
        let(:tour_id) { '123' }

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

  path '/api/v1/tours/{tour_id}/places/{id}' do
    parameter name: 'tour_id', in: :path, type: :string, description: 'tour_id'
    parameter name: 'id', in: :path, type: :string, description: 'place_id'

    get('show place of tour for all') do
      tags 'Tour'
      security [ jwt_auth: [] ]

      response(200, 'successful') do
        let(:tour_id) { '123' }
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

    put('update place of tour by partner') do
      tags 'Partner Tours'
      consumes 'multipart/form-data'
      security [jwt_auth: []]
      parameter name: :place,
                in: :formData,
                schema: {
                  type: :object,
                  properties: {
                    name: { type: :string },
                    body: { type: :string },
                    image: { type: :file }
                  }
                }

      response(200, 'successful') do
        let(:tour_id) { '123' }
        let(:place_id) { '123' }

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

    delete('delete place of tour by partner') do
      tags 'Partner Tours'
      security [jwt_auth: []]

      response(200, 'successful') do
        let(:tour_id) { '123' }
        let(:place_id) { '123' }

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
