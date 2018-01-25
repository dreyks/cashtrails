class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :select_sqlite_db

  private

  def select_sqlite_db
    current_user.try(:database) or return

    CashTrailsModel.select_user_db(current_user.database.file_path)
  end
end
