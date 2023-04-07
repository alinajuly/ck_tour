require 'rails_helper'
require 'swagger_helper'

RSpec.describe 'api/v1/caterings', type: :request do
  path '/api/v1/caterings' do
    get('list CATERING - published for all') do
      tags 'Catering'
      produces 'application/json'
      security [ jwt_auth: [] ]
      parameter name: :geolocations, in: :query, schema: { type: :string },
                description: 'Locality'
      parameter name: :user_id, in: :query, schema: { type: :integer },
                description: 'Filter on partner'
      parameter name: :status, in: :query, schema: { type: :string },
                description: 'Filter on status: unpublished/published'
      parameter name: :check_in, in: :query, schema: { type: :string },
                description: 'Guests Check-in f.e. 2023-05-15-18-00'
      parameter name: :check_out, in: :query, schema: { type: :string },
                description: 'Guests Check-out f.e. 2023-05-15-21-00'
      parameter name: :number_of_peoples, in: :query, schema: { type: :string },
                description: 'Guests quantity'

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

    post('create new CATERING - for partner only') do
      tags 'Partner Caterings'
      description 'Creates a new catering'
      consumes 'application/json'
      security [ jwt_auth: [] ]
      parameter name: :catering,
                in: :body,
                required: true,
                schema: {
                  type: :object,
                  properties: {
                    name: { type: :string },
                    description: { type: :string },
                    places: { type: :integer },
                    kind: { type: :string },
                    phone: { type: :string },
                    email: { type: :string },
                    address_owner: { type: :string },
                    reg_code: { type: :string },
                    person: { type: :string },
                    user_id: { type: :string }
                  },
                  required: [ :name, :description, :places, :address_owner, :phone, :email, :kind,
                              :user_id, :reg_code, :person ]
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

  path '/api/v1/caterings/{id}' do
    parameter name: :id, in: :path, type: :string, description: 'catering id'

    get('show CATERING - published for all') do
      tags 'Catering'
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

    put('update CATERING: status by admin: published/unpublished , other attr. by partner his own only') do
      tags 'Partner Caterings'
      consumes 'application/json'
      security [ jwt_auth: [] ]
      parameter name: :catering,
                in: :body,
                schema: {
                  type: :object,
                  properties: {
                    name: { type: :string },
                    description: { type: :string },
                    places: { type: :integer },
                    kind: { type: :string },
                    phone: { type: :string },
                    email: { type: :string },
                    address_owner: { type: :string },
                    reg_code: { type: :string },
                    person: { type: :string },
                    status: { type: :string }
                  }
                }

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

    delete('delete CATERING - for admin all, for partner his own only') do
      tags 'Partner Caterings'
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
end
