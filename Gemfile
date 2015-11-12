source 'https://rubygems.org'

gem 'rails', '4.2.4'
gem 'pg'
gem 'sqlite3'

gem 'devise'

group :servers do
  gem 'unicorn'
  gem 'unicorn-worker-killer'
end

gem 'kaminari'

gem 'simple_form'

gem 'rack-mini-profiler'
gem 'rails-footnotes'

gem 'haml-rails'

gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'therubyracer', platforms: :ruby
gem 'jquery-rails'
gem 'turbolinks'
source 'https://rails-assets.org' do
  gem 'rails-assets-bootstrap'
end

group :development do
  # Console
  gem 'pry-rails'
  gem 'pry-doc'
  gem 'pry-byebug'
  gem 'pry-rescue'
  gem 'awesome_print'

  gem 'web-console'
  gem 'quiet_assets'
  gem 'spring'
  gem 'spring-commands-rspec'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
end

group :test do
  # gem 'capybara'
  gem 'fuubar'
  # gem 'poltergeist'
end

group :tools do
  gem 'guard'
  gem 'guard-rspec'

  gem 'rubocop'
  gem 'guard-rubocop'
end
