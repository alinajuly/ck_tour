require 'rails_helper'
require 'swagger_helper'

RSpec.describe 'api/v1/accommodations', type: :request do
  let!(:user) { create(:user, role: 'partner') }
  let(:token) { JWT.encode({ user_id: user.id }, Rails.application.secret_key_base) }
  let(:headers) { { 'Authorization' => "Bearer #{token}" } }

  path '/api/v1/accommodations' do
    get('list ACCOMMODATION - published for all, unpublished for admin, his own for partner') do
      tags 'Accommodation'
      produces 'application/json'
      security [jwt_auth: []]
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
      security [jwt_auth: []]
      consumes 'multipart/form-data'
      parameter name: :accommodation,
                in: :formData,
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
                    person: { type: :string },
                    'images[]':
                      {
                        type: :array,
                        items:
                          { type: :string,
                            format: :binary }
                      }
                  },
                  required: %i[name description address_owner phone email kind user_id reg_code person]
                }

      response(201, 'successful created') do
        let(:Authorization) { headers['Authorization'] }
        let!(:accommodation)  {{ name: 'Test Accommodation', description: 'A test accommodation', kind: 'hotel',
            phone: '555-555-5555', email: 'test@test.com', reg_code: '175852451', address_owner: '123 Main St',
            person: 'John Smith', user_id: user.id }}

        it 'should returns status response' do
          expect(response.status).to eq(201)
        end

        run_test!
      end

      response(401, 'unauthorized') do
        let!(:user) { create(:user) }
        let(:token) { JWT.encode({ user_id: user.id }, Rails.application.secret_key_base) }
        let(:headers) { { 'Authorization' => "Bearer #{token}" } }
        let(:Authorization) { headers['Authorization'] }
        let!(:accommodation)  {{ name: 'Test Accommodation', description: 'A test accommodation', kind: 'hotel',
                                 phone: '555-555-5555', email: 'test@test.com', reg_code: '175852451', address_owner: '123 Main St',
                                 person: 'John Smith', user_id: user.id }}

        run_test! do
          expect(response.status).to eq(401)
        end
      end

      response(422, 'invalid request') do
        let(:Authorization) { headers['Authorization'] }
        let!(:accommodation)  {{ name: 'Test Accommodation', description: 'A test accommodation', kind: 'hotel',
                                       user_id: user.id }}

        run_test! do
          expect(response.status).to eq(422)
        end
      end
    end
  end

  path '/api/v1/accommodations/{id}' do
    parameter name: :id, in: :path, type: :string, description: 'accommodation id'
    let(:Authorization) { headers['Authorization'] }
    let!(:accommodation) { create(:accommodation, user_id: user.id) }

    get('show ACCOMMODATION published - for all, unpublished for admin, his own for partner') do
      tags 'Accommodation'
      security [jwt_auth: []]

      response(200, 'successful') do
        let(:id) { accommodation.id }

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

    put('update ACCOMMODATION: status by admin: published/unpublished , other attr. by partner his own only') do
      tags 'Partner Accommodations'
      consumes 'multipart/form-data'
      security [jwt_auth: []]
      parameter name: :accommodation,
                in: :formData,
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
                    status: { type: :string },
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
        let(:id) { accommodation.id }

        it 'returns a 200 response' do
          expect(response).to have_http_status(:ok)
        end

        run_test! do |response|
          data = JSON.parse(response.body)
          accommodation.update(name: 'Newest hotel on Cayman Islands')
          expect(Accommodation.find_by(name: 'Newest hotel on Cayman Islands')).to eq(accommodation)
          accommodation.update(description: 'Really newest hotel on Cayman Islands')
          expect(Accommodation.find_by(description: 'Really newest hotel on Cayman Islands')).to eq(accommodation)
        end
      end

      response(401, 'unauthorized') do
        let(:id) { accommodation.id }

        run_test! do |response|
          data = JSON.parse(response.body)
          accommodation.update(status: 'published')
          expect(response.status).to eq(401)
        end
      end

      response(404, 'not found') do
        let(:id) { 'invalid' }
        let(:accommodation_attributes) { attributes_for(:accommodation) }

        run_test! do
          expect(response.status).to eq(404)
        end
      end

      response(422, 'invalid request') do
        let(:id) { accommodation.id }
        let(:accommodation_attributes) { attributes_for(:accommodation, name: nil) }

        run_test! do
          expect(response.status).to eq(422)
        end
      end
    end

    delete('delete ACCOMMODATION - for admin all, for partner his own only') do
      tags 'Partner Accommodations'
      security [jwt_auth: []]

      response(204, 'no content') do
        let(:id) { accommodation.id }

        run_test! do
          expect(response.status).to eq(204)
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
