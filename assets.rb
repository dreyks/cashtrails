class Assets < Sinatra::Base
  configure do
    set :app_root, File.expand_path('../', __FILE__)

    set :sprockets,     Sprockets::Environment.new(settings.app_root)
    set :assets_prefix, '/assets'
    set :assets_path,   File.join(settings.app_root, 'assets')

    %w(stylesheets javascripts images).each do |asset_directory|
      settings.sprockets.append_path File.join(settings.assets_path, asset_directory)
    end

    if defined?(RailsAssets)
      RailsAssets.load_paths.each do |path|
        settings.sprockets.append_path(path)
      end
    end

    Sprockets::Helpers.configure do |config|
      config.environment = settings.sprockets
      config.prefix      = settings.assets_prefix
      config.digest      = true # digests are great for cache busting
      config.manifest    = Sprockets::Manifest.new(
        settings.sprockets,
        File.join(
          settings.app_root, 'public', 'assets', 'manifest.json'
        )
      )
    end
  end
end