class AccountBalance < CashTrailsModel
  self.table_name = 'accountBalances'

  belongs_to :currency, foreign_key: :currencyID
  belongs_to :account, foreign_key: :accountIDOrInvalid

  def amount_text
    "#{currency.currencyCode} #{format('%.2f', amount.to_f / 100)}"
  end

  def save
    persisted? or return super
    valid? or return

    self.class.where(account: account, currency: currency).update_all(amount: amount)
  end
end
