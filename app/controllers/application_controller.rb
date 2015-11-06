class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :select_sqlite_db

  private

  def select_sqlite_db
    connection_config = CashTrailsModel.configurations['sqlite'].clone
    endpoint = params[:user] ? 'de3b01c1311fd5bd' : 'bare'
    if connection_config['database'].gsub!(/db\/.*\.sqlite3/, "db/#{endpoint}.sqlite3")
      CashTrailsModel.establish_connection connection_config
    end
    true
  end
end
