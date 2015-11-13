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

  def rollback
    importer_session = current_user.importer_sessions.find(params[:id])
    redirect_to importers_url unless importer_session

    importer_session.items.includes(:record).map(&:record).delete_all
    importer_session.destroy

    redirect_to importers_url, notice: 'Importer session aborted.'
  end

  def commit
    importer_session = current_user.importer_sessions.find(params[:id])
    redirect_to importers_url unless importer_session

    importer_session.destroy
    redirect_to importers_url, notice: 'Finished importing.'
  end

  private

  def importer_session_params
    params.require(:importer_session).permit(:account_id, :file)
  end
end
