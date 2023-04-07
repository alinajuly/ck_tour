require 'rails_helper'
require 'swagger_helper'

RSpec.describe 'api/v1/accommodations', type: :request do
  path '/api/v1/accommodations' do
    get('list ACCOMMODATION - published for all, unpublished for admin, his own for partner') do
      tags 'Accommodation'
      produces 'application/json'
      security [ jwt_auth: [] ]
      parameter name: :geolocations, in: :query, schema: { type: :string },
                description: 'Locality'
      parameter name: :check_in, in: :query, schema: { type: :string },
                description: 'Date of check in'
      parameter name: :check_out, in: :query, schema: { type: :string },
                description: 'Date of check in'
      parameter name: :number_of_peoples, in: :query, schema: { type: :integer },
                description: 'Number of peoples'
      parameter name: :user_id, in: :query, schema: { type: :integer },
                description: 'Filter on partner'
      parameter name: :status, in: :query, schema: { type: :string },
                description: 'Filter on status: unpublished/published'

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

    post('create new ACCOMMODATION - for partner only') do
      tags 'Partner Accommodations'
      description 'Creates a new accommodation'
      consumes 'application/json'
      security [ jwt_auth: [] ]
      parameter name: :accommodation,
                in: :body,
                required: true,
                schema: {
                  type: :object,
                  properties: {
                    name: { type: :string },
                    description: { type: :string },
                    address_owner: { type: :string },
                    phone: { type: :string },
                    email: { type: :string },
                    kind: { type: :string },
                    user_id: { type: :string },
                    reg_code: { type: :string },
                    person: { type: :string }
                  },
                  required: [ :name, :description, :address_owner, :phone, :email, :kind, :user_id, :reg_code, :person ]
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

  path '/api/v1/accommodations/{id}' do
    parameter name: :id, in: :path, type: :string, description: 'accommodation id'

    get('show ACCOMMODATION published - for all, unpublished for admin, his own for partner') do
      tags 'Accommodation'
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

    put('update ACCOMMODATION: status by admin: published/unpublished , other attr. by partner his own only') do
      tags 'Partner Accommodations'
      consumes 'application/json'
      security [ jwt_auth: [] ]
      parameter name: :accommodation,
                in: :body,
                description: '',
                schema: {
                  type: :object,
                  properties: {
                    name: { type: :string },
                    description: { type: :string },
                    address_owner: { type: :string },
                    phone: { type: :string },
                    email: { type: :string },
                    kind: { type: :string },
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

    delete('delete ACCOMMODATION - for admin all, for partner his own only') do
      tags 'Partner Accommodations'
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
