class Currency < CashTrailsModel
  delegate :to_s, to: :currencyCode
end
