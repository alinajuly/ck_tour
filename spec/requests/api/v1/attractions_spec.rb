require 'rails_helper'
require 'swagger_helper'

RSpec.describe 'api/v1/attractions', type: :request do
  path '/api/v1/attractions' do
    get('list attractions for all') do
      tags 'Attraction'
      produces 'application/json'
      parameter name: :geolocations, in: :query, schema: { type: :string },
                description: 'Locality'
      parameter name: :search, in: :query, schema: { type: :string },
                description: 'Search'

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

    post('create attraction by admin') do
      tags 'Admin Attractions'
      description 'Creates a new attraction'
      security [ jwt_auth: [] ]
      consumes 'multipart/form-data'
      # consumes 'application/json'
      parameter name: :attraction,
                # in: :body,
                in: :formData,
                required: true,
                schema: {
                  type: :object,
                  properties: {
                    title: { type: :string },
                    description: { type: :string },
                    image: { type: :file }
                  },
                  required: [ :title, :description, :image ]
                }
      # parameter name: :image,
      #           in: :formData,
      #           type: :file,
      #           description: 'Image file to upload'

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

    get('show attraction for all') do
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

    put('update attraction by admin') do
      tags 'Admin Attractions'
      security [ jwt_auth: [] ]
      consumes 'multipart/form-data'
      parameter name: :attraction,
                # in: :body,
                in: :formData,
                schema: {
                  type: :object,
                  properties: {
                    title: { type: :string },
                    description: { type: :string },
                    image: { type: :file }
                  }
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

    delete('delete attraction by admin') do
      tags 'Admin Attractions'
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
  end

  # path '/api/v1/attractions/{attraction_id}/upload_image' do
  #   post('upload image of attraction by admin') do
  #     parameter name: :attraction_id, in: :path, type: :string, description: 'attraction id'
  #     tags 'Admin Attractions'
  #     consumes 'multipart/form-data'
  #     security [ jwt_auth: [] ]
  #     parameter name: 'image', in: :formData, type: :file, description: 'Image file to upload'
  #     produces 'application/json'
  #
  #     response '200', 'Image uploaded successfully' do
  #       schema type: :object,
  #              properties: {
  #                url: { type: :string, description: 'URL of the uploaded image' }
  #              }
  #       let(:id) { create(:attraction).id }
  #       let(:Authorization) { "Bearer #{JwtToken.encode(user_id: create(:user).id)}" }
  #       let(:image) { fixture_file_upload('spec/fixtures/test_image.jpg', 'image/jpg') }
  #       run_test!
  #     end
  #     response '401', 'Unauthorized' do
  #       let(:id) { create(:attraction).id }
  #       let(:image) { fixture_file_upload('spec/fixtures/test_image.jpg', 'image/jpg') }
  #       run_test!
  #     end
  #
  #     response(200, 'Image uploaded successfully') do
  #       it 'should returns status response' do
  #         expect(response.status).to eq(201)
  #       end
  #     end
  #
  #     response(401, 'unauthorized') do
  #       it 'should returns status response' do
  #         expect(response.status).to eq(401)
  #       end
  #     end
  #
  #     response(404, 'not found') do
  #       it 'should returns status response' do
  #         expect(response.status).to eq(404)
  #       end
  #     end
  #
  #     response(422, 'invalid request') do
  #       it 'should returns status response' do
  #         expect(response.status).to eq(422)
  #       end
  #     end
  #   end
  # end
  #
  # path '/api/v1/attractions/{attraction_id}/update_image' do
  #   put('update image by admin') do
  #     parameter name: :attraction_id, in: :path, type: :string, description: 'attraction id'
  #     tags 'Admin Attractions'
  #     consumes 'multipart/form-data'
  #     security [ jwt_auth: [] ]
  #     parameter name: 'image', in: :formData, type: :file, description: 'Image file to upload'
  #     produces 'application/json'
  #
  #     response '200', 'Image updated successfully' do
  #       schema type: :object,
  #              properties: {
  #                url: { type: :string, description: 'URL of the updated image' }
  #              }
  #       let(:attraction) { create(:attraction, :with_image) }
  #       let(:id) { attraction.id }
  #       let(:Authorization) { "Bearer #{JwtToken.encode(user_id: attraction.user_id)}" }
  #       let(:image) { fixture_file_upload('spec/fixtures/test_image.jpg', 'image/jpg') }
  #       run_test!
  #     end
  #     response '401', 'Unauthorized' do
  #       let(:id) { create(:attraction).id }
  #       let(:image) { fixture_file_upload('spec/fixtures/test_image.jpg', 'image/jpg') }
  #       run_test!
  #     end
  #
  #     response(200, 'Image updated successfully') do
  #       it 'should returns status response' do
  #         expect(response.status).to eq(201)
  #       end
  #     end
  #
  #     response(401, 'unauthorized') do
  #       it 'should returns status response' do
  #         expect(response.status).to eq(401)
  #       end
  #     end
  #
  #     response(404, 'not found') do
  #       it 'should returns status response' do
  #         expect(response.status).to eq(404)
  #       end
  #     end
  #
  #     response(422, 'invalid request') do
  #       it 'should returns status response' do
  #         expect(response.status).to eq(422)
  #       end
  #     end
  #   end
  # end
end
