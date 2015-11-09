class DatabasesController < ApplicationController
  def new
  end

  def create
    render :new_db and return unless (file = params[:upload][:file]).present?

    current_user.database = Database.new(file: file.tempfile)
    current_user.save

    redirect_to accounts_path
  end
end
