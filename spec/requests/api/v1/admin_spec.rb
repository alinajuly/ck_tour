require 'rails_helper'
require 'swagger_helper'

RSpec.describe 'api/v1/admins', type: :request do
  let!(:admin) { create(:user, role: 'admin') }
  let(:token) { JWT.encode({ user_id: admin.id }, Rails.application.secret_key_base) }
  let(:headers) { { 'Authorization' => "Bearer #{token}" } }

  path '/api/v1/admins/create_admin' do
    post('create admin') do
      tags 'Users Admin'
      description 'Creates a new admin'
      consumes 'application/json'
      security [jwt_auth: []]
      parameter name: :user,
                in: :body,
                required: true,
                schema: {
                  type: :object,
                  properties: {
                    name: { type: :string },
                    email: { type: :string },
                    password: { type: :string }
                  },
                  required: %i[name email password]
                }

      let(:Authorization) { headers['Authorization'] }

      response(201, 'successful created') do
        let(:user) { { name: 'Jack Dow', email: 'jackdow@test.com', password: 'Password123!' } }

        it 'should returns status response' do
          expect(response.status).to eq(201)
          json = JSON.parse(response.body).deep_symbolize_keys
          expect(json[:email]).to eq('jackdow@test.com')
          expect(json[:name]).to eq('Jack Dow')
          expect(json[:role]).to eq('admin')
        end

        run_test!
      end

      response(401, 'unauthorized') do
        let(:Authorization) { nil }
        let(:user) { { name: 'Jack Dow', email: 'jackdow@test.com', password: 'Password123!' } }
        it 'should returns status response' do
          expect(response.status).to eq(401)
        end

        run_test!
      end

      response(422, 'invalid request') do
        let(:user) { { name: 'Jack Dow', email: 'jackdow@test.com', password: '123' } }
        it 'should returns status response' do
          expect(response.status).to eq(422)
        end

        run_test!
      end
    end
  end

  path '/api/v1/admins/unpublished_comments' do
    get('list unpublished comments for admin only') do
      tags 'Comment'
      produces 'application/json'
      security [jwt_auth: []]
      let(:Authorization) { headers['Authorization'] }
      let!(:attraction) { create(:attraction) }
      let!(:user) { create(:user, email: 'new_user_tourist@test.com') }
      let(:token) { JWT.encode({ user_id: user.id }, Rails.application.secret_key_base) }
      let(:headers) { { 'Authorization' => "Bearer #{token}" } }
      let(:Authorization) { headers['Authorization'] }
      let!(:comment) { create(:comment, commentable_id: attraction.id, user_id: user.id) }
      let(:token) { JWT.encode({ user_id: admin.id }, Rails.application.secret_key_base) }
      let(:headers) { { 'Authorization' => "Bearer #{token}" } }
      let(:Authorization) { headers['Authorization'] }

      response(200, 'successful') do
        it 'should returns status response' do
          expect(response.status).to eq(200)
        end

        run_test!
      end

      response(401, 'unauthorized') do
        let(:Authorization) { nil }
        it 'should returns status response' do
          expect(response.status).to eq(401)
        end

        run_test!
      end
    end
  end
end
