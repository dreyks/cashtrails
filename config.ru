require 'tilt/haml' # get rid of tilt warning
require 'bundler'
require 'bundler/setup'
Bundler.require

Dir.glob("./models/*") { |file| require file }
require './utils.rb'
require './app'
require './assets'

# TODO: restrict only to dev
map Assets.settings.prefix do
  run Assets.sprockets
end
# main app
map '/' do
  run CashTrails::App
end