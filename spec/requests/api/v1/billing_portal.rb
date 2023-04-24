require 'rails_helper'
require 'swagger_helper'

RSpec.describe 'api/v1/billing_portal_controller', type: :request do

  path '/api/v1/billing_portal_index' do
    put('billing portal for authenticated user') do
      tags 'Billing portal'
      produces 'application/json'
      parameter name: :token, in: :query, type: :string, description: 'Authorization token'

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
