module CashTrails
  class App < Sinatra::Base
    register Sinatra::ActiveRecordExtension

    configure do
      set :database, adapter: 'sqlite3', database: 'db/db.sqlite3'
    end

    configure :development do
      register Sinatra::Reloader
      Dir['./models/*'].each { |file| also_reload file }
    end

    helpers do
      include Sprockets::Helpers
    end

    get '/' do
      haml :index
    end

    get '/accounts' do
      @accounts = Account.includes({balances: :currency}, :account_group).order(:accountGroupIDOrInvalid, :accountOrder)
      haml :accounts
    end

    get '/records' do
      @records = Record.includes(:source_account, :target_account, :source_currency, :source_currency_foreign, :target_currency, :target_currency_foreign).
        order(gmtDate: :desc, gmtTime: :desc).page params[:page]
      haml :records
    end

    get '/upload' do
      haml :upload
    end
  end
end