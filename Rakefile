require 'bundler'
Bundler.require

require './app'
require './assets'
require 'sinatra/activerecord/rake'

namespace :assets do
  desc "Precompile assets"
  task :precompile do
    environment = Assets.sprockets
    manifest = Sprockets::Manifest.new(environment.index, Assets.assets_path)
    manifest.compile(Assets.assets_precompile)
  end

  desc "Clean assets"
  task :clean do
    FileUtils.rm_rf(Assets.assets_path)
  end
end