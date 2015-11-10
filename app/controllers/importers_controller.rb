class ImportersController < ApplicationController
  before_action :set_importer, only: [:show, :edit, :update, :destroy]

  def index
    @importers = Importer.all
  end

  def show
  end

  def new
    @importer = Importer.new
  end

  def edit
  end

  def create
    @importer = Importer.new(importer_params)

    if @importer.save
      redirect_to @importers_url, notice: 'Importer was successfully created.'
    else
      render :new
    end
  end

  def update
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
