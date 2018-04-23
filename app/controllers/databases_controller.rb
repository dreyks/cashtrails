class DatabasesController < ApplicationController
  def new; end

  def create
    render :new_db and return unless (file = params[:upload][:file]).present?

    current_user.database = Database.new(file: file.tempfile, name: database_name)
    current_user.save

    redirect_to accounts_path
  end

  private

  def database_name
    Rails.env.development? ? current_user.id : nil
  end
end
