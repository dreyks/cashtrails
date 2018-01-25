class RecordsController < ApplicationController
  def index
    @records = Record.order(gmtDate: :desc, gmtTime: :desc).page params[:page]
  end

  def edit
    @record = Record.find(params[:id])
  end

  def show
    @record = Record.find(params[:id])
  end
end
