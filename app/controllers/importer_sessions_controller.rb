class ImporterSessionsController < ApplicationController
  def new
    @importer_session = current_user.importer_sessions.new(importer_id: params[:importer_id])
  end

  def create
    @importer_session = current_user.importer_sessions.new(importer_session_params)
    @importer_session.importer_id = params[:importer_id]

    if @importer_session.save
      redirect_to @importer_session
    else
      render :new
    end
  end

  def show
    @importer_session = current_user.importer_sessions.find(params[:id])
  end

  def destroy
    @importer_session = current_user.importer_sessions.find(params[:id])
    @importer_session.destroy
    # TODO: handle wrong user
    redirect_to importers_url, notice: 'Importer session aborted.'
  end

  private

  def importer_session_params
    params.require(:importer_session).permit(:account_id, :file)
  end
end
