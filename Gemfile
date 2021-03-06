source 'https://rubygems.org'

ruby '2.6.2'

gem 'rails', '5.2.3'
# load miniprofiler before pg because otherwise sqlite queries aren't being logged
gem 'rack-mini-profiler'
gem 'pg', '~> 1.0'
gem 'sqlite3'

gem 'devise'

group :servers do
  gem 'unicorn'
  gem 'unicorn-worker-killer'
end

gem 'kaminari'

gem 'simple_form'
gem 'enum_help'

gem 'haml-rails'

gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'jquery-rails'
gem 'turbolinks'
source 'https://rails-assets.org' do
  gem 'rails-assets-bootstrap', '~> 3'
end

group :development do
  # Console
  gem 'pry-rails'
  gem 'pry-doc'
  gem 'pry-byebug'
  gem 'pry-rescue'
  gem 'awesome_print'

  gem 'web-console'
  gem 'spring'
  gem 'spring-commands-rspec'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'factory_bot_rails'
end

group :test do
  # gem 'capybara'
  gem 'fuubar'
  gem 'database_cleaner'
  # gem 'poltergeist'
end

group :tools do
  gem 'guard'
  gem 'guard-rspec'

  gem 'rubocop'
  gem 'guard-rubocop'
end
