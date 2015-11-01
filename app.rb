require 'sinatra/base'
require 'sinatra/activerecord'

class CashTrails < Sinatra::Base
  register Sinatra::ActiveRecordExtension

  configure do
    set :database, adapter: 'sqlite3', database: 'db/db.sqlite3'
  end

  get '/' do
    'test'
  end

  get '/upload' do
    haml :upload
  end
end