require 'rails_helper'
require 'swagger_helper'

RSpec.describe "Api::V1::Facilities", type: :request do
  path '/api/v1/accommodations/{accommodation_id}/facilities' do
    # You'll want to customize the parameter types...
    parameter name: 'accommodation_id', in: :path, type: :string, description: 'accommodation_id'

    post('create facility') do
      tags 'Facility'
      consumes 'application/json'
      security [ jwt_auth: [] ]
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

  path '/api/v1/accommodations/{accommodation_id}/facilities/{id}' do
    # You'll want to customize the parameter types...
    parameter name: 'accommodation_id', in: :path, type: :string, description: 'accommodation_id'
    parameter name: 'id', in: :path, type: :string, description: 'id'

    get('show facility') do
      tags 'Facility'

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

    put('update facility') do
      tags 'Facility'
      consumes 'application/json'
      security [ jwt_auth: [] ]
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
                  },
                  required: false
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

    delete('delete facility') do
      tags 'Facility'
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
