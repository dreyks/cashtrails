require 'tilt/haml' # get rid of tilt warning
require 'bundler'
require 'bundler/setup'
Bundler.require

require './app'
require './assets'


map Assets.settings.assets_prefix do
  run Assets.sprockets
end
# main app
map '/' do
  run CashTrails::App
end