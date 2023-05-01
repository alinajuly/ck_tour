require 'rails_helper'
require 'swagger_helper'
require_relative '../../../../app/controllers/concerns/json_web_token'

RSpec.describe 'api/v1/tours', type: :request do
  let!(:user) { create(:user, role: 'partner') }
  let(:token) { JWT.encode({ user_id: user.id }, Rails.application.secret_key_base) }
  let(:headers) { { 'Authorization' => "Bearer #{token}" } }

  path '/api/v1/tours' do
    get('list TOUR - published for all') do
      tags 'Tour'
      produces 'application/json'
      security [ jwt_auth: [] ]
      parameter name: :geolocations, in: :query, schema: { type: :string },
                description: 'Locality'
      parameter name: :user_id, in: :query, schema: { type: :integer },
                description: 'Filter on partner'
      parameter name: :status, in: :query, schema: { type: :string },
                description: 'Filter on status: unpublished/published'
      parameter name: :archived, in: :query, schema: { type: :string },
                description: 'Archive of old tours'

      let(:Authorization) { headers['Authorization'] }
      let!(:tour1) { create(:tour, user_id: user.id) }
      let!(:tour2) { create(:tour, user_id: user.id, status: 'published') }
      let!(:places) { [] }
      let(:geolocations) { nil }
      let(:user_id) { nil }
      let(:status) { 'unpublished' }
      let(:archived) { nil }

      response(200, 'successful') do
        it 'should returns status response' do
          expect(response.status).to eq(200)
        end

        run_test!
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
                    price_per_one: { type: :integer },
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
        let(:Authorization) { headers['Authorization'] }
        let!(:tour) { build(:tour, user_id: user.id) }

        run_test! do
          expect(response.status).to eq(201)
        end
      end

      response(401, 'unauthorized') do
        let!(:user) { create(:user) }
        let(:token) { JWT.encode({ user_id: user.id }, Rails.application.secret_key_base) }
        let(:headers) { { 'Authorization' => "Bearer #{token}" } }
        let(:Authorization) { headers['Authorization'] }
        let!(:tour) { build(:tour, user_id: user.id) }

        run_test! do
          expect(response.status).to eq(401)
        end
      end

      response(422, 'invalid request') do
        let(:Authorization) { headers['Authorization'] }
        let!(:tour) { build(:tour, user_id: user.id, time_start: Date.today - 7) }

        run_test! do
          expect(response.status).to eq(422)
        end
      end
    end
  end

  path '/api/v1/tours/{id}' do
    parameter name: :id, in: :path, type: :string, description: 'tour id'
    let(:Authorization) { headers['Authorization'] }
    let!(:tour) { create(:tour, user_id: user.id) }

    get('show TOUR - published for all') do
      tags 'Tour'
      produces 'application/json'
      security [ jwt_auth: [] ]

      response(200, 'successful') do
        let(:id) { tour.id }

        it 'should returns status response' do
          expect(response.status).to eq(200)
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
                    price_per_one: { type: :integer },
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
        let(:id) { tour.id }

        run_test! do
          expect(response.status).to eq(200)
        end

        run_test! do
          tour.update(title: 'The Best Tour of the Year')
          expect(Tour.find_by(title: 'The Best Tour of the Year')).to eq(tour)
          tour.update(description: 'Really the Best')
          expect(Tour.find_by(description: 'Really the Best')).to eq(tour)
        end
      end

      response(401, 'unauthorized') do
        let(:id) { tour.id }
        let(:Authorization) { nil }

        run_test! do |response|
          data = JSON.parse(response.body)
          tour.update(title: 'The Best Tour of the Year')
          expect(response.status).to eq(401)
        end
      end

      response(404, 'not found') do
        let(:id) { 'invalid' }
        let(:tour_attributes) { attributes_for(:tour) }

        run_test! do
          expect(response.status).to eq(404)
        end
      end

      response(422, 'invalid request') do
        let(:id) { tour.id }
        let(:tour_attributes) { attributes_for(:tour, time_start: Date.today - 7) }

        run_test! do
          expect(response.status).to eq(422)
          expect(json[:time_start]).to eq(["can't be in the past"])
        end
      end
    end

    delete('delete TOUR - for admin all, for partner his own only') do
      tags 'Partner Tours'
      security [ jwt_auth: [] ]

      response(200, 'successful') do
        let(:id) { tour.id }

        run_test! do
          expect(response.status).to eq(200)
        end
      end

      response(401, 'unauthorized') do
        let(:id) { tour.id }
        let(:Authorization) { nil }

        run_test! do
          expect(response.status).to eq(401)
        end
      end

      response(404, 'not found') do
        let(:id) { 'invalid' }

        run_test! do
          expect(response.status).to eq(404)
        end
      end
    end
  end
end
