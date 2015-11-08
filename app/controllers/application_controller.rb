class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :select_sqlite_db

  private

  def select_sqlite_db
    db_name = (user_signed_in? ? current_user.db : false) || 'bare'

    connection_config = CashTrailsModel.configurations['sqlite'].clone
    if connection_config['database'].gsub!(/db\/.*\.sqlite3/, "db/#{db_name}.sqlite3")
      CashTrailsModel.establish_connection connection_config
    end
    true
  end
end
