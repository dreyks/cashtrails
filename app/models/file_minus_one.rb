class FileMinusOne < CashTrailsModel
  self.table_name = 'recordFiles'

  belongs_to :record, foreign_key: :recordID, inverse_of: :file_minus_one

  default_scope { where(fileRelaxedOrderOrMinusOne: -1, fileIDOrInvalid: 0) }
end
