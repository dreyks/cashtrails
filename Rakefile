require 'bundler'
Bundler.require

require './app'
require './assets'
require 'sinatra/activerecord/rake'

namespace :assets do
  desc "Precompile assets"
  task :precompile do
    environment = Assets.sprockets
    manifest = Sprockets::Manifest.new(environment.index, Assets.target_path)
    # manifest.clean(1)
    manifest.compile(Assets.precompile)
  end

  desc "Clean assets"
  task :clean do
    FileUtils.rm_rf(Assets.target_path)
  end
end