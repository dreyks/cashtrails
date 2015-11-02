module CashTrails
  class App < Sinatra::Base
    register Sinatra::ActiveRecordExtension

    configure do
      set :database, adapter: 'sqlite3', database: 'db/db.sqlite3'
    end

    configure :development do
      register Sinatra::Reloader
    end

    helpers do
      include Sprockets::Helpers
    end

    get '/' do
      haml :index
    end

    get '/upload' do
      haml :upload
    end
  end
end