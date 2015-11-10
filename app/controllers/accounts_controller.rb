class AccountsController < ApplicationController
  def index
    @accounts = Account.includes({balances: :currency}, :account_group)
  end
end
