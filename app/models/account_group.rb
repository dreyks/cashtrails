class AccountGroup < CashTrailsModel
  self.table_name = 'accountGroups'

  has_many :accounts, foreign_key: :accountGroupIDOrInvalid
end