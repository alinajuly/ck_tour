require 'swagger_helper'

RSpec.describe 'api/v1/bookings', type: :request do
  path '/api/v1/users/{id}/bookings' do
    parameter name: :id, in: :path, type: :string, description: 'user id'

    get('list bookings') do
      tags 'Booking'
      produces 'application/json'

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
      parameter name: :booking,
                in: :body,
                required: true,
                schema: {
                  type: :object,
                  properties: {
                    number_of_peoples: { type: :integer },
                    check_in: { type: :date },
                    check_out: { type: :date },
                    note: { type: :text },
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
    parameter name: :id, in: :path, type: :string, description: 'user id'
    parameter booking: :id, in: :path, type: :string, description: 'booking id'

    get('show booking') do
      tags 'Booking'
    
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

    patch('update booking') do
      tags 'Booking'
      consumes 'application/json'
      parameter name: :booking,
                in: :body,
                required: true,
                schema: {
                  type: :object,
                  properties: {
                    number_of_peoples: { type: :integer },
                    check_in: { type: :date },
                    check_out: { type: :date },
                    note: { type: :text },
                    confirmation: { type: :integer }
                  },
                  required: [ :number_of_peoples, :check_in, :check_out, :note ]
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

    put('update booking') do
      tags 'Booking'
      consumes 'application/json'
      parameter name: :booking,
                in: :body,
                required: true,
                schema: {
                  type: :object,
                  properties: {
                    number_of_peoples: { type: :integer },
                    check_in: { type: :date },
                    check_out: { type: :date },
                    note: { type: :text },
                    confirmation: { type: :integer }
                  },
                  required: [ :number_of_peoples, :check_in, :check_out, :confirmation ]
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
