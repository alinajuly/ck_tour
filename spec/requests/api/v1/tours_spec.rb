require 'rails_helper'
require 'swagger_helper'

RSpec.describe 'api/v1/tours', type: :request do
  path '/api/v1/tours' do
    get('list TOUR - published for all') do
      tags 'Tour'
      produces 'application/json'
      parameter name: :geolocations, in: :query, schema: { type: :string },
                description: 'Locality'
      parameter name: :user_id, in: :query, schema: { type: :integer },
                description: 'Filter on partner'
      parameter name: :archived, in: :query, schema: { type: :string },
                description: 'Archive of old tours'

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

    post('create new TOUR - for partner only') do
      tags 'Partner Tours'
      description 'Creates a new tour'
      consumes 'application/json'
      security [ jwt_auth: [] ]
      parameter name: :tour,
                in: :body,
                required: true,
                schema: {
                  type: :object,
                  properties: {
                    title: { type: :string },
                    description: { type: :string },
                    seats: { type: :integer },
                    price_per_one: { type: :decimal },
                    time_start: { type: :string },
                    time_end: { type: :string },
                    phone: { type: :string },
                    email: { type: :string },
                    address_owner: { type: :string },
                    reg_code: { type: :string },
                    person: { type: :string },
                    user_id: { type: :string }
                  },
                  required: [ :title, :description, :seats, :address_owner, :phone, :email, :price_per_one,
                              :user_id, :reg_code, :person, :time_start, :time_end ]
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

  path '/api/v1/tours/{id}' do
    parameter name: :id, in: :path, type: :string, description: 'tour id'

    get('show TOUR - published for all') do
      tags 'Tour'

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

    put('update TOUR: status by admin: published/unpublished , other attr. by partner his own only') do
      tags 'Partner Tours'
      consumes 'application/json'
      security [ jwt_auth: [] ]
      parameter name: :tour,
                in: :body,
                schema: {
                  type: :object,
                  properties: {
                    title: { type: :string },
                    description: { type: :string },
                    seats: { type: :integer },
                    price_per_one: { type: :decimal },
                    time_start: { type: :string },
                    time_end: { type: :string },
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

    delete('delete TOUR - for admin all, for partner his own only') do
      tags 'Partner Tours'
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

  path '/api/v1/tours_unpublished' do
    get('list unpublished (for admin - all, for partner - his own only)') do
      tags 'Admin Tours'
      consumes 'application/json'
      security [ jwt_auth: [] ]

      response(200, 'successful') do
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

  path '/api/v1/tours/{id}/show_unpublished' do
    parameter name: :id, in: :path, type: :string, description: 'tour id'

    get('list unpublished (for admin - all, for partner - his own only)') do
      tags 'Admin Tours'
      consumes 'application/json'
      security [ jwt_auth: [] ]

      response(200, 'successful') do
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
end
