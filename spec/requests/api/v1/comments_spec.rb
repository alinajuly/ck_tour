require 'rails_helper'
require 'swagger_helper'

RSpec.describe 'api/v1/comments', type: :request do
  let!(:admin) { create(:user, role: 'admin') }
  let(:token) { JWT.encode({ user_id: admin.id }, Rails.application.secret_key_base) }
  let(:headers) { { 'Authorization' => "Bearer #{token}" } }
  let(:Authorization) { headers['Authorization'] }
  let!(:parent) { create(:attraction) }
  let!(:user) { create(:user, email: 'new_tourist@test.com') }
  let(:token) { JWT.encode({ user_id: user.id }, Rails.application.secret_key_base) }
  let(:headers) { { 'Authorization' => "Bearer #{token}" } }
  let(:Authorization) { headers['Authorization'] }

  path '/api/v1/{parentable_type}/{parentable_id}/comments' do
    parameter name: 'parentable_type', in: :path, type: :string, description: 'f.e. attractions, accommodations, catering, tour'
    parameter name: 'parentable_id', in: :path, type: :string, description: 'f.e. attraction_id, accommodation_id, catering_id, tour_id'
    let(:parentable_type) { 'attractions' }
    let(:parentable_id) { parent.id }

    get('list comments - published for all, unpublished for admin, his own for partner/tourist') do
      tags 'Comment'
      produces 'application/json'
      security [jwt_auth: []]
      parameter name: :status, in: :query, schema: { type: :string },
                description: 'Filter on status: unpublished/published'
      let!(:comment) { create(:comment, commentable_id: parent.id, user_id: user.id) }
      let(:status) { nil }

      response(200, 'successful') do
        it 'should returns status response' do
          expect(response.status).to eq(200)
        end

        run_test!
      end

      response(404, 'not found') do
        let(:parentable_id) { 'invalid' }
        it 'should returns status response' do
          expect(response.status).to eq(404)
        end

        run_test!
      end
    end

    post('create comment by authenticated user') do
      tags 'Comment'
      consumes 'application/json'
      security [jwt_auth: []]
      parameter name: :comment,
                in: :body,
                required: true,
                schema: {
                  type: :object,
                  properties: {
                    body: { type: :string }
                  },
                  required: %i[body]
                }
      let(:comment) { FactoryBot.attributes_for(:comment) }

      response(201, 'successful created') do
        it 'should returns status response' do
          expect(response.status).to eq(201)
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

      response(422, 'invalid request') do
        let(:comment) { FactoryBot.attributes_for(:comment, body: 'No') }
        it 'should returns status response' do
          expect(response.status).to eq(422)
        end

        run_test!
      end
    end
  end

  path '/api/v1/{parentable_type}/{parentable_id}/comments/{id}' do
    parameter name: 'parentable_type', in: :path, type: :string, description: 'f.e. attractions, accommodations, catering, tour'
    parameter name: 'parentable_id', in: :path, type: :string, description: 'f.e. attraction_id, accommodation_id, catering_id, tour_id'
    parameter name: :id, in: :path, type: :string, description: 'comment id'
    let(:parentable_type) { 'attractions' }
    let(:parentable_id) { parent.id }
    let!(:admin) { create(:user, role: 'admin') }
    let!(:comment) { create(:comment, commentable_id: parent.id, user_id: user.id) }
    let(:token) { JWT.encode({ user_id: admin.id }, Rails.application.secret_key_base) }
    let(:headers) { { 'Authorization' => "Bearer #{token}" } }
    let(:Authorization) { headers['Authorization'] }

    get('show comment for all') do
      tags 'Comment'
      security [jwt_auth: []]

      response(200, 'successful') do
        let(:id) { comment.id }

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

    put('update comment by admin or partner') do
      tags 'Comment'
      consumes 'application/json'
      security [jwt_auth: []]
      parameter name: :comment,
                in: :body,
                required: false,
                schema: {
                  type: :object,
                  properties: {
                    status: { type: :string }
                  }
                }

      response(200, 'successful') do
        let(:id) { comment.id }
        let(:new_attributes) { { status: 'published' } }

        before do
          puts admin.inspect
          puts comment.inspect
        end

        it 'updates the requested comment' do
          put "/api/v1/attractions/#{parent.id}/comments/#{comment.id}", params: new_attributes
          comment.reload
          expect(comment.status).to eq('published')
          expect(response).to eq(200)
        end
      end

      response(401, 'unauthorized') do
        let(:Authorization) { nil }
        it 'should returns status response' do
          put "/api/v1/attractions/#{parent.id}/rates/#{comment.id}", params: new_attributes
          expect(response.status).to eq(401)
        end
      end

      response(422, 'invalid request') do
        let(:id) { comment.id }
        let(:new_attributes) { { status: 'approved' } }

        it 'updates the requested comment' do
          put "/api/v1/attractions/#{parent.id}/comments/#{comment.id}", params: new_attributes
          comment.reload
          expect(response).to eq(422)
        end
      end
    end

    delete('delete comment by admin or partner') do
      tags 'Comment'
      security [jwt_auth: []]

      response(204, 'no content') do
        let(:id) { comment.id }
        it 'should returns status response' do
          expect(response.status).to eq(204)
        end

        run_test!
      end

      response(401, 'unauthorized') do
        let(:id) { comment.id }
        let(:Authorization) { nil }
        it 'should returns status response' do
          expect(response.status).to eq(401)
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
  end
end
