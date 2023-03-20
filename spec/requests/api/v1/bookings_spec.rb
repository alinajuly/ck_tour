require 'swagger_helper'

RSpec.describe 'api/v1/bookings', type: :request do

  path '/api/v1/users/{id}/bookings' do
    parameter name: 'user_id', in: :path, type: :string, description: 'user id'
    
    get('list booking') do
      tags 'Booking'
      produces 'application/json'
      security [ jwt_auth: [] ]
      
      response(200, 'successful') do
        it 'should returns status response' do
          expect(response.status).to eq(200)
        end

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end

    post('create booking') do
      tags 'Booking'
      description 'Creates a new booking'
      consumes 'application/json'
      security [ jwt_auth: [] ]
      parameter name: :booking,
                in: :body,
                required: true,
                schema: {
                  type: :object,
                  properties: {
                    number_of_peoples: { type: :integer },
                    check_in: { type: :string, format: :date },
                    check_out: { type: :string, format: :date },
                    note: { type: :string },
                    confirmation: { type: :integer }
                  },
                  required: [ :number_of_peoples, :check_in, :check_out ]
                }
      
      response(201, 'successful') do
        it 'should returns status response' do
          expect(response.status).to eq(201)
        end

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end
  end

  path '/api/v1/users/{id}/bookings/{id}' do
    # You'll want to customize the parameter types...
    parameter name: 'user_id', in: :path, type: :string, description: 'user id'
    parameter name: 'booking_id', in: :path, type: :string, description: 'booking id'

    get('show booking') do
      tags 'Booking'
      security [ jwt_auth: [] ]
    
      response(200, 'successful') do
        it 'should returns status response' do
          expect(response.status).to eq(200)
        end

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end

    put('update booking') do
      tags 'Booking'
      consumes 'application/json'
      security [ jwt_auth: [] ]
      parameter name: :booking,
                in: :body,
                required: true,
                schema: {
                  type: :object,
                  properties: {
                    number_of_peoples: { type: :integer },
                    check_in: { type: :string, format: :date },
                    check_out: { type: :string, format: :date },
                    note: { type: :string },
                    confirmation: { type: :integer }
                  },
                  required: false
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
        run_test!
      end
    end

    delete('delete booking') do
      tags 'Booking'
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
        run_test!
      end
    end
  end
end
