source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.2"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.0.4", ">= 7.0.4.2"

# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 5.0"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
# gem "jbuilder"

# Use Redis adapter to run Action Cable in production
# gem "redis", "~> 4.0"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use JSON Web Token (JWT) for token based authentication
gem 'jwt', '~> 2.7'

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# accept payments online
gem 'stripe', '~> 8.3'

# Use Active Storage variants
gem 'image_processing', '~> 1.12', '>= 1.12.2'

gem "aws-sdk-s3", require: false

# RuboCop is a Ruby static code analyzer (a.k.a. linter) and code formatter
gem 'rubocop', require: false

# Fake data for seeds
gem 'faker', '~> 3.1', '>= 3.1.1'

# Generate API documentation and rspec integration tests
gem 'rswag', '~> 2.8'

gem 'net-smtp', require: false
gem 'net-imap', require: false
gem 'net-pop', require: false

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors'

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  gem 'rspec-rails'
  gem 'rswag-specs'
end

group :development do
  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
  gem 'capistrano'
  gem 'capistrano-rvm'
  gem 'capistrano-rails'
  gem 'capistrano3-puma'
  gem 'capistrano-nginx'
  gem 'capistrano-upload-config'
  gem 'capistrano-rbenv'
  gem 'sshkit-sudo'
  
  # generate preview of e-mail instead of sending
  gem 'letter_opener', '~> 1.8', '>= 1.8.1'
end

# A Ruby binding to the Ed25519 elliptic curve public-key signature system described in RFC 8032.
gem 'ed25519'
 
#  This gem implements bcrypt_pdkfd (a variant of PBKDF2 with bcrypt-based PRF)
gem 'bcrypt_pbkdf'

# Alternative to the standard IRB shell for Ruby. It features syntax highlighting, a flexible plugin architecture, runtime invocation and source and documentation browsing
gem 'pry'

# Pundit provides a set of helpers which guide you in leveraging regular Ruby classes and object oriented design patterns to build a simple, robust and scalable authorization system
gem 'pundit'

# Simple, Heroku-friendly Rails app configuration using ENV and a single YAML file
gem "figaro"
