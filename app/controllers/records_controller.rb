class RecordsController < ApplicationController
  def index
    @records = Record.all

    if params[:account_id]
      @record = @records.
          where(account1IDOrInvalid: params[:account_id]).
          or(Record.where(account2IDOrInvalid: params[:account_id]))
    end

    @records = @records.
        order(gmtDate: :desc, gmtTime: :desc).
        page params[:page]
  end

  def edit
    @record = Record.find(params[:id])
  end

  def update
    @record = Record.find(params[:id])

    if @record.update(record_params)
      render :show
    else
      head 400
    end
  end

  def show
    @record = Record.find(params[:id])
  end

  private

  def record_params
    params.require(:record).permit(
      :id,
      :kind,
      :occured_at,
      :account1IDOrInvalid,
      :source_amount,
      :currency1IDOrInvalid,
      :account2IDOrInvalid,
      :target_amount,
      :currency3IDOrInvalid,
      {tag_ids: []},
      :groupIDOrInvalid,
      :partyIDOrInvalid,
      :note
    )
  end
end
