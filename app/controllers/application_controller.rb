class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :select_sqlite_db

  private

  def select_sqlite_db
    db_name = (user_signed_in? ? current_user.database.file_path : false) || 'bare'

    connection_config = CashTrailsModel.configurations["sqlite_#{Rails.env}"].clone
    if connection_config['database'].replace db_name
      CashTrailsModel.establish_connection connection_config
    end
    true
  end
end
