require 'rails_helper'
require 'swagger_helper'

RSpec.describe 'api/v1/appointments', type: :request do
  let!(:partner) { create(:user, role: 'partner') }
  let(:token) { JWT.encode({ user_id: partner.id }, Rails.application.secret_key_base) }
  let(:headers) { { 'Authorization' => "Bearer #{token}" } }
  let(:Authorization) { headers['Authorization'] }
  let!(:tour) { create(:tour, user_id: partner.id) }
  let!(:user) { create(:user, email: 'tourist888@test.com') }
  let(:token) { JWT.encode({ user_id: user.id }, Rails.application.secret_key_base) }
  let(:headers) { { 'Authorization' => "Bearer #{token}" } }
  let(:Authorization) { headers['Authorization'] }

  path '/api/v1/users/{id}/appointments' do
    parameter name: 'id', in: :path, type: :string, description: 'user id'
    let(:id) { user.id }

    get('list TOUR APPOINTMENT for tourist') do
      tags 'Tourist Tours'
      produces 'application/json'
      security [jwt_auth: []]
      parameter name: :archived, in: :query, schema: { type: :string },
                description: 'Archive of old appointments'
      let(:archived) { nil }

      response(200, 'successful') do
        let!(:appointment) { create(:appointment, tour_id: tour.id, user_id: user.id) }

        it 'should returns status response' do
          expect(response.status).to eq(200)
        end

        run_test!
      end
    end
  end

  path '/api/v1/users/{user_id}/appointments/{id}' do
    parameter name: 'user_id', in: :path, type: :string, description: 'user id'
    parameter name: 'id', in: :path, type: :string, description: 'appointment id'
    let(:user_id) { user.id }
    let!(:appointment) { create(:appointment, tour_id: tour.id, user_id: user.id) }
    let(:id) { appointment.id }

    get('show TOUR APPOINTMENT for tourist') do
      tags 'Tourist Tours'
      security [jwt_auth: []]

      response(200, 'successful') do
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

    put('update TOUR APPOINTMENT: confirmation (approved/cancelled) - partner only, other attr. by tourist') do
      tags 'Tourist Tours'
      consumes 'application/json'
      security [jwt_auth: []]
      parameter name: :appointment,
                in: :body,
                schema: {
                  type: :object,
                  properties: {
                    number_of_peoples: { type: :integer },
                    note: { type: :string },
                    phone: { type: :string },
                    full_name: { type: :string },
                    confirmation: { type: :string }
                  }
                }

      response(200, 'successful') do
        let(:id) { appointment.id }

        run_test! do
          expect(response.status).to eq(200)
        end

        run_test! do
          appointment.update(note: 'additional peoples!!!')
          expect(Appointment.find_by(note: 'additional peoples!!!')).to eq(appointment)
          appointment.update(number_of_peoples: 15)
          expect(Appointment.find_by(number_of_peoples: 15)).to eq(appointment)
        end
      end

      response(401, 'unauthorized') do
        let(:id) { appointment.id }
        let(:Authorization) { nil }

        run_test! do |response|
          appointment.update(note: 'additional peoples!!!')
          expect(response.status).to eq(401)
        end
      end

      response(404, 'not found') do
        let(:id) { 'invalid' }
        let(:appointment_attributes) { attributes_for(:appointment) }

        run_test! do
          expect(response.status).to eq(404)
        end
      end
    end

    delete('delete TOUR APPOINTMENT by tourist') do
      tags 'Tourist Tours'
      security [jwt_auth: []]

      response(200, 'successful') do
        let(:id) { appointment.id }

        run_test! do
          expect(response.status).to eq(200)
        end
      end

      response(401, 'unauthorized') do
        let(:id) { appointment.id }
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

  path '/api/v1/tours/{tour_id}/appointments' do
    parameter name: 'tour_id', in: :path, type: :string, description: 'tour id'
    let(:tour_id) { tour.id }

    get('list TOUR APPOINTMENT for partner') do
      tags 'Partner Tours'
      produces 'application/json'
      security [jwt_auth: []]
      parameter name: :archived, in: :query, schema: { type: :string },
                description: 'Archive of old appointments'
      let(:archived) { nil }

      response(200, 'successful') do
        let!(:appointment) { create(:appointment, tour_id: tour.id, user_id: user.id) }
        let(:token) { JWT.encode({ user_id: partner.id }, Rails.application.secret_key_base) }
        let(:headers) { { 'Authorization' => "Bearer #{token}" } }
        let(:Authorization) { headers['Authorization'] }

        it 'should returns status response' do
          expect(response.status).to eq(200)
        end

        run_test!
      end

      response(401, 'unauthorized') do
        let!(:appointment) { create(:appointment, tour_id: tour.id, user_id: user.id) }

        it 'should returns status response' do
          expect(response.status).to eq(401)
        end

        run_test!
      end
    end

    post('create TOUR APPOINTMENT by tourist') do
      tags 'Tourist Tours'
      consumes 'application/json'
      security [jwt_auth: []]
      parameter name: :appointment,
                in: :body,
                required: true,
                schema: {
                  type: :object,
                  properties: {
                    number_of_peoples: { type: :integer },
                    note: { type: :string },
                    phone: { type: :string },
                    full_name: { type: :string },
                    tour_id: { type: :integer }
                  },
                  required: %i[number_of_peoples tour_id]
                }

      response(201, 'successful created') do
        let!(:appointment) { build(:appointment, tour_id: tour.id, user_id: user.id) }

        it 'should returns status response' do
          expect(response.status).to eq(201)
          json = JSON.parse(response.body).deep_symbolize_keys
          expect(json[:number_of_peoples]).to eq(5)
          expect(json[:phone]).to eq(appointment.phone)
          expect(json[:full_name]).to eq(appointment.full_name)
        end

        run_test!
      end

      response(401, 'unauthorized') do
        let(:Authorization) { nil }
        let!(:appointment) { build(:appointment, tour_id: tour.id, user_id: user.id) }

        it 'should returns status response' do
          expect(response.status).to eq(401)
        end

        run_test!
      end

      response(422, 'invalid request') do
        let!(:appointment) { build(:appointment, number_of_peoples: -5) }

        it 'should returns status response' do
          expect(response.status).to eq(422)
        end

        run_test!
      end
    end
  end
end
