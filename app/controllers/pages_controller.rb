class PagesController < ApplicationController
  def root
  end

  def new_db
  end

  def upload_db
    return unless params[:upload][:file]

    db_name = SecureRandom.hex(4)
    target = Rails.root.join('db', "#{db_name}.sqlite3")

    FileUtils.cp(params[:upload][:file].tempfile, target)

    current_user.db = db_name
    current_user.save
    redirect_to accounts_path
  end
end
