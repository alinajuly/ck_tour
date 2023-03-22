require 'rails_helper'
require 'swagger_helper'

RSpec.describe 'api/v1/attractions', type: :request do
  path '/api/v1/attractions' do
    get('list attractions') do
      tags 'Attraction'
      produces 'application/json'
      parameter name: :toponyms, in: :query, schema: { type: :string },
                description: 'Locality'

      response(200, 'successful') do
        it 'should returns status response' do
          expect(response.status).to eq(200)
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

    post('create attraction') do
      tags 'Attraction'
      description 'Creates a new attraction'
      consumes 'application/json'
      security [ jwt_auth: [] ]
      parameter name: :attraction,
                in: :body,
                required: true,
                schema: {
                  type: :object,
                  properties: {
                    title: { type: :string },
                    description: { type: :string }
                  },
                  required: [ :title, :description ]
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

  path '/api/v1/attractions/{id}' do
    # You'll want to customize the parameter types...
    parameter name: :id, in: :path, type: :string, description: 'attraction id'

    get('show attraction') do
      tags 'Attraction'

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

    put('update attraction') do
      tags 'Attraction'
      consumes 'application/json'
      security [ jwt_auth: [] ]
      parameter name: :attraction,
                in: :body,
                required: true,
                schema: {
                  type: :object,
                  properties: {
                    title: { type: :string },
                    description: { type: :string }
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

    delete('delete attraction') do
      tags 'Attraction'
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

    path '/api/v1/search' do
      get('search article') do
        tags 'Attraction'
        consumes 'application/json'
        parameter name: :req, in: :query, schema: { type: :string },
                  description: 'Search attractions by phrase in title, description or locality'
        response(200, 'successful') do
          let(:req) { 'Черкаси' }
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
end
