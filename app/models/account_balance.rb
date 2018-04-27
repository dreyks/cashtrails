class AccountBalance < CashTrailsModel
  self.table_name = 'accountBalances'

  attribute :amount, :amount, zeroed_nil: true

  belongs_to :currency, foreign_key: :currencyID
  belongs_to :account, foreign_key: :accountIDOrInvalid

  def amount_text
    Utils.format_money(amount, currency)
  end

  def save
    persisted? or return super
    valid? or return

    self.class.where(account: account, currency: currency).update_all(amount: amount)
  end
end
