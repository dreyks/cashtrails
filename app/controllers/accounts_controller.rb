class AccountsController < ApplicationController
  def index
    @accounts = Account.includes({balances: :currency}, :account_group).order(:accountGroupIDOrInvalid, :accountOrder)
  end
end