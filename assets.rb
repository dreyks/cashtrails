class Assets < Sinatra::Base
  configure do
    set :app_root, File.expand_path('../', __FILE__)

    set :sprockets,     Sprockets::Environment.new(settings.app_root)
    set :source_folder, 'assets'
    set :prefix, '/assets'
    set :target_path,   File.join(settings.app_root, 'public', 'assets')
    set :precompile, %w(app.js app.css *.png *.jpg *.svg *.eot *.ttf *.woff *.woff2)

    %w(stylesheets javascripts images).each do |asset_directory|
      settings.sprockets.append_path File.join(settings.app_root, settings.source_folder, asset_directory)
    end

    if defined?(RailsAssets)
      RailsAssets.load_paths.each do |path|
        settings.sprockets.append_path(path)
      end
    end

    Sprockets::Helpers.configure do |config|
      config.environment = settings.sprockets
      config.prefix      = settings.prefix
      config.digest      = true # digests are great for cache busting
      config.manifest    = Sprockets::Manifest.new(
        settings.sprockets,
        target_path
      )
    end
  end
end