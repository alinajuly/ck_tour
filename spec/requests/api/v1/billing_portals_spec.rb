require 'rails_helper'
require 'swagger_helper'

RSpec.describe 'api/v1/billing_portals_controller', type: :request do
  path '/api/v1/billing_portals' do
    post('billing portal for authenticated user') do
      tags 'Billing portal'
      produces 'application/json'
      security [jwt_auth: []]

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
