  # frozen_string_literal: true

require 'rails_helper'

RSpec.configure do |config|
  # Specify a root folder where Swagger JSON files are generated
  # NOTE: If you're using the rswag-api to serve API descriptions, you'll need
  # to ensure that it's configured to serve Swagger from the same folder
  config.swagger_root = Rails.root.join('swagger').to_s

  # Define one or more Swagger documents and provide global metadata for each one
  # When you run the 'rswag:specs:swaggerize' rake task, the complete Swagger will
  # be generated at the provided relative path under swagger_root
  # By default, the operations defined in spec files are added to the first
  # document below. You can override this behavior by adding a swagger_doc tag to the
  # the root example_group in your specs, e.g. describe '...', swagger_doc: 'v2/swagger.json'
  config.swagger_docs = {
    'v1/swagger.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'API V1',
        version: 'v1'
      },
      tags: [
        { name: 'Users',
          description: 'User operating for all roles' },
        { name: 'Users Tourist',
          description: 'User operating for tourist' },
        { name: 'Users Admin',
          description: 'User operating for admin' },
        { name: 'Attraction',
          description: 'Views of attractions for all' },
        { name: 'Admin Attractions',
          description: 'operate with attractions by admin' },
        { name: 'Accommodation',
          description: 'Views of accommodations for all' },
        { name: 'Partner Accommodations',
          description: 'operate with accommodations by partner' },
        { name: 'Tourist Accommodations',
          description: 'operate with accommodations by tourist' },
        { name: 'Catering',
          description: 'Views of caterings for all' },
        { name: 'Partner Caterings',
          description: 'operate with caterings by partner' },
        { name: 'Tourist Caterings',
          description: 'operate with caterings by tourist' },
        { name: 'Tour',
          description: 'Views of tours for all' },
        { name: 'Partner Tours',
          description: 'operate with tours by partner' },
        { name: 'Tourist Tours',
          description: 'operate with tours by tourist' },
        { name: 'Map',
          description: 'operate with maps' },
        { name: 'Comment',
          description: "operate with user's comments" },
        { name: 'Rate',
          description: "operate with user's rates" }
      ],
      paths: {},
      servers: [
        {
          url: 'http://{defaultHost}',
          variables: {
            defaultHost: {
              default: 'localhost:3000'
            }
          }
        },
        {
          url: 'https://{ck_tour_Host}',
          variables: {
            ck_tour_Host: {
              default: 'cktour.club'
            }
          }
        }
      ],
      # Define the security scheme type (HTTP bearer)
      components: {
        securitySchemes: {
          jwt_auth: {
            type: :http,
            scheme: :bearer,
            bearerFormat: 'JWT'
          }
        }
      }
    }
  }

  # Specify the format of the output Swagger file when running 'rswag:specs:swaggerize'.
  # The swagger_docs configuration option has the filename including format in
  # the key, this may want to be changed to avoid putting yaml in json files.
  # Defaults to json. Accepts ':json' and ':yaml'.
  config.swagger_format = :yaml
end
