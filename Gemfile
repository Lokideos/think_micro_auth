# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

gem 'rake', '~> 13.0.0'
gem 'puma', '~> 4.3.0'
gem 'roda', '~> 3.33.0'

gem 'i18n', '~> 1.8.2'
gem 'config', '~> 2.2.1'

gem 'pg', '~> 1.2.3'
gem 'sequel', '~> 5.32.0'
gem 'bunny', '~> 2.15.0'

gem 'sequel_secure_password', '~> 0.2.0'

gem 'dry-initializer', '~> 3.0.3'
gem 'dry-validation', '~> 1.5.0'

gem 'activesupport', '~> 6.0.0', require: false
gem 'fast_jsonapi', '~> 1.5'

gem 'pry', '~> 0.13.0'
gem 'bcrypt', '~> 3.1.0'
gem 'jwt', '~> 2.2.1'

gem 'rack-ougai', '~> 0.2.1'
gem 'rack-request-id', '~> 0.0.4'

group :development, :test do
  gem 'pry-byebug', '~> 3.9.0'
  gem 'amazing_print'

  gem 'rspec', '~> 3.9.0'
  gem 'fabrication', '~> 2.21.0'
  gem 'rack-test', '~> 1.1.0'
  gem 'database_cleaner-sequel', '~> 1.8.0'

  gem 'rack-unreloader', '~> 1.7.0'
end