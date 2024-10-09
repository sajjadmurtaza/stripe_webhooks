source 'https://rubygems.org'

gem 'rails', '~> 8.0.0.beta1'
gem 'sqlite3', '>= 2.1'
gem 'puma', '>= 5.0'
gem 'tzinfo-data', platforms: %i[ windows jruby ]

gem 'pg', '~> 1.5.8'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

# Deploy this application anywhere as a Docker container [https://kamal-deploy.org]
gem 'kamal', '>= 2.0.0.rc2', require: false

# Add HTTP asset caching/compression and X-Sendfile acceleration to Puma [https://github.com/basecamp/thruster/]
gem 'thruster', require: false

gem 'stripe', '~> 12.6.0'
gem 'sidekiq', '~> 7.3.0'

group :development, :test do
  gem 'debug', platforms: %i[ mri windows ], require: 'debug/prelude'
  gem 'pry'
  gem 'brakeman', require: false
  gem 'rubocop-rails-omakase', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop', require: false
  gem 'rubocop-rspec', require: false
  gem 'rubocop-rails', require: false
  gem 'annotate'
  gem 'dotenv-rails'
end

group :test do
  gem 'vcr'
  gem 'webmock'
  gem 'rspec-rails', '~> 7.0.1'
  gem 'factory_bot_rails'
end
