class ImportersController < ApplicationController
  before_action :set_importer, only: [:show, :edit, :update, :destroy]

  def index
    @importers = current_user.importers
  end

  def show
  end

  def new
    @importer = current_user.importers.new
  end

  def edit
    head :forbidden unless @importer.user == current_user
  end

  def create
    @importer = current_user.importers.new(importer_params)

    if @importer.save
      redirect_to importers_url, notice: 'Importer was successfully created.'
    else
      render :new
    end
  end

  def update
    head :forbidden and return unless @importer.user == current_user

    if @importer.update(importer_params)
      redirect_to importers_url, notice: 'Importer was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @importer.destroy
    redirect_to importers_url, notice: 'Importer was successfully destroyed.'
  end

  private

  def set_importer
    @importer = Importer.find(params[:id])
  end

  def importer_params
    params.require(:importer).permit(:name, :date_field, :amount_field, :foreign_amount_field, :description_field)
  end
end
