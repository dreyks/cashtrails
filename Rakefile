require './app'
require 'sinatra/activerecord/rake'

namespace :assets do
          desc "Precompile assets"
          task :precompile do
            environment = app_klass.sprockets
            manifest = Sprockets::Manifest.new(environment.index, app_klass.assets_path)
            manifest.compile(app_klass.assets_precompile)
          end

          desc "Clean assets"
          task :clean do
            FileUtils.rm_rf(app_klass.assets_path)
          end
        end