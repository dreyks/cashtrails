class RecordsController < ApplicationController
  def index
    @records = Record.includes(
      :source_account,
      :target_account,
      :source_currency,
      :source_currency_foreign,
      :target_currency,
      :target_currency_foreign,
      :tags,
      :group
    ).order(gmtDate: :desc, gmtTime: :desc).page params[:page]
  end
end
