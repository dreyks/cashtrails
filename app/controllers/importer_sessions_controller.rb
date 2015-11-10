class ImporterSessionsController < ApplicationController
  def new
    @importer_session = current_user.importer_sessions.new(importer_id: params[:importer_id])
  end

  def create
    @importer_session = current_user.importer_sessions.new(params[:importer_session])

    if @importer_session.save
      redirect_to @importer_session
    else
      render :new
    end
  end
end
