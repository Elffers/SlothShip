source 'https://rubygems.org'

gem 'rails', '4.0.2'
gem 'pg'
gem 'sass-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'jbuilder', '~> 1.2'
gem "httparty", "~> 0.13.0"
gem "active_shipping", "~> 0.11.2"
gem "figaro"

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

group :development, :test do
  gem "rspec-rails"
  gem "factory_girl_rails"
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'simplecov', :require => false
end

group :test do
  gem "webmock", "~> 1.17.3"
  gem "vcr", "~> 2.8.0"
end

group :production do
  gem 'rails_12factor'
end
