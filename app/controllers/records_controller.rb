class RecordsController < ApplicationController
  def index
    @records = Record.with_includes.order(gmtDate: :desc, gmtTime: :desc).page params[:page]
  end
end
