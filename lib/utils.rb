module Utils
  def self.format_money(amount, currency)
    "#{currency.currencyCode} #{format('%.2f', amount.to_f)}"
  end
end
