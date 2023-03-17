require 'swagger_helper'

RSpec.describe 'api/v1/accommodations', type: :request do
  let(:accommodation) { 
    Accommodation.create(
      name: 'Hotel Selena Family Resort', 
      description: 'Цей готель розташований у тихому місці поруч з Дніпром. Інфраструктура готелю налічує літню терасу і ресторан. 
                    Гостям пропонується оренда велосипедів, тенісні корти, SUP-борди, прогулянки по Дніпру, рибалка, 
                    а також лазні на дровах з виходом на річку, а також можливість користуватися різноманітними спортивними майданчиками'
                      .encode("UTF-8"),
      address: 'Дахнівська, 21 Черкаси 19622', 
      kind: 'hotel', 
      phone: '0472545454', 
      email: 'selena@sample.com'
    ) 
  }
  
  path '/api/v1/accommodations' do
    get('list accommodations') do
      tags 'Accommodation'
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

    post('create accommodation') do
      tags 'Accommodation'
      description 'Creates a new accommodation'
      consumes 'application/json'
      parameter name: :accommodation,
                in: :body,
                required: true,
                schema: {
                  type: :object,
                  properties: {
                    name: { type: :string },
                    description: { type: :string },
                    address: { type: :string },
                    phone: { type: :string },
                    email: { type: :string, format: :email },
                    kind: { type: :string, enum: [ 'hotel', 'hostel', 'apartment', 'greenhouse' ] }
                  },
                  required: [ :name, :description, :address, :phone, :email, :kind ]
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

  path '/api/v1/accommodations/{id}' do
    # You'll want to customize the parameter types...
    parameter name: :id, in: :path, type: :string, description: 'accommodation id'

    get('show accommodation') do
      tags 'Accommodation'
    
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

    patch('update accommodation') do
      tags 'Accommodation'
      consumes 'application/json'
      parameter name: :accommodation,
                in: :body,
                required: true,
                schema: {
                  type: :object,
                  properties: {
                    name: { type: :string },
                    description: { type: :string },
                    address: { type: :string },
                    phone: { type: :string },
                    email: { type: :string, format: :email },
                    kind: { type: :string, enum: [ 'hotel', 'hostel', 'apartment', 'greenhouse' ] }
                  },
                  required: [ :name, :description, :address, :phone, :email, :kind ]
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

    put('update accommodation') do
      tags 'Accommodation'
      consumes 'application/json'
      parameter name: :accommodation,
                in: :body,
                required: true,
                schema: {
                  type: :object,
                  properties: {
                    name: { type: :string },
                    description: { type: :string },
                    address: { type: :string },
                    phone: { type: :string },
                    email: { type: :string, format: :email },
                    kind: { type: :string, enum: [ 'hotel', 'hostel', 'apartment', 'greenhouse' ] }
                  },
                  required: [ :name, :description, :address, :phone, :email, :kind ]
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

    delete('delete accommodation') do
      tags 'Accommodation'
      
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
